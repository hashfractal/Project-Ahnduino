using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ahnduino
{
	public class Request
	{
		public string Date { get; set; }
		public string DocID { get; set; }
		public string HopeDate1 { get; set; }
		public string Text { get; set; }
		public string Title { get; set; }
		public List<string> Image { get; set; }
		public bool isreserv { get; set; }
		public string reserv { get; set; }
		public bool solved { get; set; }


		public Request(string Date, string DocID, string HopeDate1, string Text,
			string Title, bool isreserv, string reserv, bool solved)
		{
			this.Date = Date;
			this.DocID = DocID;
			this.HopeDate1 = HopeDate1;
			this.Text = Text;
			this.Title = Title;
			this.isreserv = isreserv;
			this.reserv = reserv;
			this.solved = solved;
		}
	}
}