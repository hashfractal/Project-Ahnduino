using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Google.Cloud.Firestore;

namespace Ahnduino
{
    public partial class addbill : MetroFramework.Forms.MetroForm
    {
        FireBase fb = new FireBase();
        string address;
        int paypermonth;

        DocumentSnapshot snap;
        public addbill(string address, int paypermonth)
        {
            InitializeComponent();
            this.address = address;
            this.paypermonth = paypermonth;
        }

        private void addbill_Load(object sender, EventArgs e)
        {
            metroTextBoxyear.Text = DateTime.Now.ToString("yyyy");
            metroTextBoxppm.Text = paypermonth.ToString();

            CollectionReference docref = fb.DB.Collection("Bill");
            Query query = docref.WhereEqualTo("address", address);
            QuerySnapshot querySnapshot = query.GetSnapshotAsync().Result;
            foreach (DocumentSnapshot documentSnapshot in querySnapshot.Documents)
            {
                snap = documentSnapshot;
            }
            object temp;
            snap.TryGetValue("money", out temp);

            metroTextBoxppm.Text = temp.ToString();
        }

        private void metroButton1_Click(object sender, EventArgs e)
        {
            Close();
        }
    }
}
