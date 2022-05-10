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
			return ((bool)type! ? "사용자" : "관리자") + ": " + text + "\n\r" + time + "\n\r\n\r";
		}
	}
}
