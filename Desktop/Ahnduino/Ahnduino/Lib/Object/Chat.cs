using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Google.Cloud.Firestore;

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

		public override string ToString()
		{
			Timestamp ts = (Timestamp)time!;
			DateTime dt = ts.ToDateTime();
			dt.AddHours(9);

			return (string.Format("{0:[HH:mm]} {1}: {2}", dt, (bool)type! ? "[사용자]" : "[관리자]" ,text ));
		}
	}
}
