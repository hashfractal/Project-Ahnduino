using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Google.Cloud.Firestore;
using System.Windows.Controls;
using Ahnduino.Lib;

namespace Ahnduino.Lib.Object
{
	[FirestoreData]
	public class Chat
	{
		[FirestoreProperty]
		public string? chat { get; set; }
		[FirestoreProperty]
		public string? text { get; set; }
		[FirestoreProperty]
		public Timestamp? time { get; set; }
		[FirestoreProperty]
		public bool? type { get; set; }
		public List<string>? imagelist { get; set; }

		public List<Image>? trueimage { get; set; }

		public string? address { get; set; }

		public string? date { get; set; }
		public bool? isfirst { get; set; }

		public override string ToString()
		{
			Timestamp ts = (Timestamp)time!;
			DateTime dt = ts.ToDateTime();
			dt = dt.AddHours(9);

			return string.Format("{0:HH:mm}", dt);
		}
	}
}
