using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace log_parser
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length <6)
            {
                Console.WriteLine("Invalid args\r\n");
                Console.WriteLine("Press <Enter> to close...");
                Console.ReadLine();

                return;
            }
            else {
                try {
                    if (!File.Exists(args[1])) {

                        Console.WriteLine("File '"+ args[1] + "' does not exists\r\n");
                        Console.WriteLine("Press <Enter> to close...");
                        Console.ReadLine();

                        return;
                    }
                    else {
                        List<string> data = new List<string>();
                        List<string> _data = new List<string>();


                        using (FileStream fs = File.Open(args[1], FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
                        using (BufferedStream bs = new BufferedStream(fs))
                        using (StreamReader sr = new StreamReader(bs, Encoding.Default)) {
                            
                            string line=string.Empty;
                            string json_line = string.Empty;

                            Data log = new Data();
                                                        
                            while ((line = sr.ReadLine()) != null) {
                                string pattern = @"^\d{2}:\d{2}:\d{2}";
                                Match m = Regex.Match(line, pattern, RegexOptions.IgnoreCase);
                                if (m.Success) {
                                    log.timestamp = DateTime.Now.ToString("yyyy-MM-dd") + "T" + line.Substring(0, 12).Replace(",", ".");
                                    log.node = args[0];
                                    log.severity = line.Split(' ')[1];
                                    log.module = line.Substring(line.IndexOf('['), (line.IndexOf(']')- line.IndexOf('[')+1));
                                    log.message= new Data().ClearText(line.Substring(12))+" ";

                                    json_line = "{\"index\": {\"_index\":\"" + args[4] + "\"}}\r\n";
                                    json_line += "{\"timestamp\": \"" + log.timestamp + "\",\"node\": \"" + log.node + "\", \"severity\": \"" + log.severity + "\", \"module\": \"\", \"message\": \"" + log.message + "\"}";

                                    data.Add(json_line);
                                    
                                }
                                else {
                                    log.message += line+" ";
                                    json_line = "{\"index\": {\"_index\":\"" + args[3] + "\"}}\r\n";
                                    json_line += "{\"timestamp\": \"" + log.timestamp + "\",\"node\": \"" + log.node + "\", \"severity\": \"" + log.severity + "\", \"module\": \"\", \"message\": \"" + log.message + "\"}";

                                    data[data.Count-1] = json_line;
                                }
                            }
                        }

                        var file = new Files();
                        /*
                            args[]:
                            0: ia-modes-1.cdu.so
                            1: Monitel_Modes_Host-2021-10-27.log
                            2: "C:\Projects\linux-dev\elk\elk-project\elasticsearch\logs\Processed"
                            3: data
                            4: logs-modes
                            5: 50
                        */

                        int i = 0;

                        int skip = 0;
                        int step = 1000;

                        int w = data.Count % step;
                        bool process = true;

                        while (process) {
                            if (data.Count - skip > data.Count % step) {
                                _data = data.GetRange(skip, step);
                                file.SaveListToFile(_data, args[2] + "" + args[3] + "-" + i.ToString() + ".json");

                                
                                if (file.GetFileSize(args[2] + "" + args[3] + "-" + i.ToString() + ".json") > Convert.ToDouble(args[5]) * 1024 * 1024) {
                                    i += 1;
                                }
                                
                                skip += step;

                            }
                            else {
                                _data = data.GetRange(skip, w);
                                file.SaveListToFile(_data, args[2] + "" + args[3] + "-" + i.ToString() + ".json");
                                process = false;
                            }

                        }
                        
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine("{0} Exception: ", e);
                    Console.WriteLine("Press <Enter> to close...");
                    Console.ReadLine();
                }
               
            }
        }
    }
}
