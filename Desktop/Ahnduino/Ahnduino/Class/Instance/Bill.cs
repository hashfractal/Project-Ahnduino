using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Google.Cloud.Firestore;

namespace Ahnduino
{
	[FirestoreData]
	internal class Bill
	{
		[FirestoreProperty]
		public string Date { get; set; }
		[FirestoreProperty]
		public bool Pay { get; set; }

		public Bill(string date, bool pay)
		{
			Date = date;
			Pay = pay;
		}

		public Bill() { }
	}
}
