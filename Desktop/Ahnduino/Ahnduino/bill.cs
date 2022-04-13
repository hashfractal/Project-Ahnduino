using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Google.Cloud.Firestore;

namespace Ahnduino
{
	[FirestoreData]
	internal class bill
	{
		[FirestoreProperty]
		public string Date { get; set; }
		[FirestoreProperty]
		public string Pay { get; set; }
	}
}
