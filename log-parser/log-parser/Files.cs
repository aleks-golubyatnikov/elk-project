using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace log_parser
{
    public class Files
    {
        public void SaveToFile(string _data, string _path)
        {
            try {
                using (var tw = new StreamWriter(_path, true)) {
                    tw.WriteLine(_data);
                    tw.Close();
                }
            }
            catch (Exception) {
                throw;
            }
        }

        public void WriteTextLog(string _line)
        {
            try {
                string _path = DateTime.Now.ToString("yyyy-MM-dd") + "-logs-process.txt";
                
                using (var tw = new StreamWriter(_path, true)) {
                    tw.WriteLine(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")+" " +_line);
                    tw.Close();
                }
            }
            catch (Exception) {
                throw;
            }
        }

        public void SaveListToFile(List<String> _data, string _path)
        {
            try {
                System.IO.File.AppendAllLines(_path, _data);
            }
            catch (Exception) {
                throw;
            }
        }

        public void SaveLineFile(String _line, string _path)
        {
            try {
                using (StreamWriter sw = File.AppendText(_path)) {
                    sw.WriteLine(_line);
                }
            }
            catch (Exception) {
                throw;
            }
        }

        public double GetFileSize(string _path)
        {
            try {
                double len = new FileInfo(_path).Length;
                return len;
            }
            catch (Exception) {
                throw;
            }
        }

    }
}
