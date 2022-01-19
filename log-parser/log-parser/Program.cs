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
            if (args.Length <4)
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

                                    json_line = "{\"index\": {\"_index\":\"" + args[3] + "\"}}\r\n";
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
                        file.SaveListToFile(data, args[2]);
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
