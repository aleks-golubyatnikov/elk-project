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
                    tw.WriteLine(_data.ToString());
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
                System.IO.File.WriteAllLines(_path, _data);
            }
            catch (Exception) {
                throw;
            }
        }

    }
}
