using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;
using System.IO;
using System.Diagnostics;
using System.Collections.Generic;


//AppContext.SetSwitch("Switch.System.Xml.AllowDefaultResolver", true);

namespace ConsoleApp1
{
    internal class Program
    {
        static void convert_wtl_xml()
        {
            XslTransform xslt = new XslTransform();
            string cur = Directory.GetCurrentDirectory();
            xslt.Load(cur+"//configs//Complete.xslt");

            XPathDocument mydata = new XPathDocument("CheckCertification.wtl");


            XmlWriterSettings settings = new XmlWriterSettings();
            settings.Indent = true;
            settings.IndentChars = "\t";
            XmlWriter writer = XmlWriter.Create(cur+"//Results//Complete.html", settings);

            xslt.Transform(mydata, null, writer, null);
            writer.Close();
        }

        static void convert_wtl_xml_fail()
        {
            XslTransform xslt = new XslTransform();
            string cur = Directory.GetCurrentDirectory();
            xslt.Load(cur+"//configs//Failure.xslt");

            XPathDocument mydata = new XPathDocument("CheckCertification.wtl");


            XmlWriterSettings settings = new XmlWriterSettings();
            settings.Indent = true;
            settings.IndentChars = "\t";
            XmlWriter writer = XmlWriter.Create(cur+"//Results//Fail.html", settings);

            xslt.Transform(mydata, null, writer, null);
            writer.Close();
        }

        static void Main(string[] args)
        {
            string my_path = Directory.GetCurrentDirectory();
            List<string> m = new List<string>() { "CheckCertification_failedlist.txt", "Matches.txt", "NoMatches.txt", "Results.xml", "CheckCertification.wtl" };
            Process process = Process.Start("DriverAssessment.exe", "/checklogo");
            int id = process.Id;
            Process tempProc = Process.GetProcessById(id);

            tempProc.WaitForExit();

            if (!Directory.Exists("Results"))
            {
                Directory.CreateDirectory("Results");
            }

            convert_wtl_xml();
            convert_wtl_xml_fail();

            foreach (string a in m)
            {
                File.Delete(a);
            }

            ProcessStartInfo startInfo = new ProcessStartInfo()
            {
                Arguments = my_path+"\\Results",
                FileName = "explorer.exe"
            };

            Process.Start(startInfo);
            




        }
    }
}
