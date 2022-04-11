using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Google.Cloud.Firestore;

namespace Ahnduino
{
	internal class FireBase
	{
		FirestoreDb DB;

		private void initialize()
		{
			string path = AppDomain.CurrentDomain.BaseDirectory + @"ahnduino-firebase-adminsdk-ddl6q-daf19142ac.json";
			Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", path);

			DB = FirestoreDb.Create("ahnduino");
		}

		void Add_Document_with_AutoID()
		{
			CollectionReference coll = DB.Collection("Add_Document_Width_AutoID");
			Dictionary<string, object> data1 = new Dictionary<string, object>()
			{
				{"FirestName", "Kim" },
				{"LastName","Jinwon" },
				{"PhoneNumber", "010-1234-5678" }
			};
			coll.AddAsync(data1);
		}
	}
}