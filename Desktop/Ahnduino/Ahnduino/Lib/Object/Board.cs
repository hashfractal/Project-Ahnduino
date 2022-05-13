using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using Google.Cloud.Firestore;

namespace Ahnduino.Lib.Object
{
	[FirestoreData]
	public class Board
	{
		[FirestoreProperty]
		public string? Date { get; set; }
		[FirestoreProperty]
		public string? DocID { get; set; }

		public List<Image>? imagelist { get; set; }
		[FirestoreProperty]
		public int? likes { get; set; }
		[FirestoreProperty]
		public string? name { get; set; }
		[FirestoreProperty]
		public string? text { get; set; }
		[FirestoreProperty]
		public Timestamp time { get; set; }
		[FirestoreProperty]
		public string? title { get; set; }
		[FirestoreProperty]
		public string? user { get; set; }

		public override string ToString()
		{
			Timestamp timestamp = time;
			DateTime date = timestamp.ToDateTime();
			date = date.AddHours(9);
			return string.Format("{0:yyyy/MM/dd} | {1}", date, title);
		}
	}
}
