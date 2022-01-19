using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace log_parser
{
    public class Data
    {
        public string timestamp { get; set; }
        public string node { get; set; }
        public string module { get; set; }
        public string severity { get; set; }
        public string message { get; set; }
        public string ClearText (string tx)
        {
            tx = tx.Replace("`r`n", "");
            tx = tx.Replace("`n", "");
            tx = tx.Replace("`r", "");
            tx = tx.Replace(";", "");
            tx = tx.Replace(":", "");
            tx = tx.Replace("\\","");
            tx = tx.Replace("-", "");
            tx = tx.Replace("``", "");
            tx = tx.Replace("\"","");

            return tx;
        }

    }

}

