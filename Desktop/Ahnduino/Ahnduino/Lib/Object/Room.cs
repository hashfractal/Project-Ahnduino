using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Google.Cloud.Firestore;
using Ahnduino.Lib;

namespace Ahnduino.Lib.Object
{
	[FirestoreData]
	internal class Room
	{
		[FirestoreProperty]
		public string? docID { get; set; }

		[FirestoreProperty]
		public string? image { get; set; }

		[FirestoreProperty]
		public string? text { get; set; }

		[FirestoreProperty]
		public Timestamp? time { get; set; }

		[FirestoreProperty]
		public string? title { get; set; }

	}
}
