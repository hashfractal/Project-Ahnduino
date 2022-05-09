using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Google.Cloud.Firestore;

namespace Ahnduino.Lib.Object
{
	public class Request
	{
		public string? Date { get; set; }
		public string? DocID { get; set; }
		public string? Text { get; set; }
		public Timestamp? Time { get; set; }
		public string? Title { get; set; }
		public string? UID { get; set; }
		public bool? Isreserve { get; set; }
		public string? Reserve { get; set; }
		public bool? Solved { get; set; }
		public string? UserName { get; set; }
		public List<string>? Images { get; set; }

		public Request(string date, string docID, string text, Timestamp time, string title, string uid, bool isReserve, string reserve, bool solved, string userName, List<string> images)
		{
			Date = date;
			DocID = docID;
			Text = text;
			Time = time;
			Title = title;
			UID = uid;
			Isreserve = isReserve;
			Reserve = reserve;
			Solved = solved;
			UserName = userName;
			Images = images;
		}
	}
}
