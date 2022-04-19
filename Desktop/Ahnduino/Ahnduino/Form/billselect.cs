using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Ahnduino
{
	public partial class billselect : MetroFramework.Forms.MetroForm
	{
		FireBase FireBase = new FireBase();

		List<Bill> bills = new List<Bill>();
		Bill bill = null;

		int paypermonth = 0;

		#region userdeffunc
		private int datetonumer(string billdate)
		{
			string[] temps = billdate.Split('-');
			string temp = temps[0] + temps[1];
			return int.Parse(temp);
		}

		private void resetBills()
        {
			bills.Clear();
			
			for(int i = 1; i <= 12; i++)
            {
				bills.Add(new Bill("0000-" + i,false));
            }
        }
		#endregion

		
		
		public billselect()
		{
			InitializeComponent();
		}

		private void metroComboBoxdate_SelectedIndexChanged(object sender, EventArgs e)
		{
			int misspay = 0;
			int totalpay = 0;
			bill = bills.Find(x => x.date == metroComboBoxdate.Text);

			for (int i = 0; datetonumer(bills[i].date) < datetonumer(bill.date) ; i++)
			{
				if(bills[i].pay == false)
				{
					misspay += paypermonth;
				}
			}

			totalpay = paypermonth + misspay;

			if (bill.pay)
			{
				metroToggle1.Checked = true;
			}
			else
			{
				metroToggle1.Checked = false;
			}

			metroLabelresaddress.Text = metroTextBoxsearch.Text;
			metroLabelrespay.Text = bill.pay ? "완납" : "미납";
			metroLabelresdate.Text = string.Format("{0}년 {1}월분", bill.date.Substring(0, 4), bill.date.Substring(5,2));
			metroLabelresmoney.Text = string.Format("당월 부과액: {0}원", paypermonth);
			metroLabelresmiss.Text = string.Format("미납액: {0}원", misspay);
			metroLabelrestotalmoney.Text = string.Format("총 부과액: {0}원", totalpay);
			metroLabelreslimit.Text = string.Format("납부 마감일 {0}월 말일", int.Parse(bill.date.Substring(5,2)) + 1);
		}

		private void metroButton1_Click(object sender, EventArgs e)
		{
			bills = FireBase.GetBillList(metroTextBoxsearch.Text, out paypermonth);
			metroComboBoxdate.Items.Clear();

			foreach (Bill bill in bills)
				metroComboBoxdate.Items.Add(bill.date);
			metroComboBoxdate.SelectedIndex = metroComboBoxdate.Items.Count - 1;
		}

		private void metroTextBoxsearch_Enter(object sender, EventArgs e)
		{
			if(metroTextBoxsearch.Text == "건물 주소 +호수   예) 동대전로1번길1롤아파트a동101호")
			{
				metroTextBoxsearch.ForeColor = Color.Black;
				metroTextBoxsearch.Text = "";
			}
		}

		private void metroTextBoxsearch_Leave(object sender, EventArgs e)
		{
			if (metroTextBoxsearch.Text == "")
			{
				metroTextBoxsearch.ForeColor = Color.Gray;
				metroTextBoxsearch.Text = "건물 주소 +호수   예) 동대전로1번길1롤아파트a동101호";
			}
		}

		private void billselect_Load(object sender, EventArgs e)
		{
			metroTextBoxsearch.Text = "건물 주소 +호수   예) 동대전로1번길1롤아파트a동101호";
		}

		private void metroToggle1_CheckedChanged(object sender, EventArgs e)
		{
			bill.pay = metroToggle1.Checked;
			metroLabelrespay.Text = bill.pay ? "완납" : "미납";

			for (int i = 0; datetonumer(bills[i].date) < datetonumer(bill.date); i++)
			{
				bills[i].pay = true;
			}

			metroComboBoxdate_SelectedIndexChanged(sender, e);

		}

        private void metroButtonupdate_Click(object sender, EventArgs e)
        {
			FireBase.UpdateBillList(bills, metroTextBoxsearch.Text);
		}

        private void metroButtoninsert_Click(object sender, EventArgs e)
        {
			addbill addbill = new addbill(metroTextBoxsearch.Text, paypermonth);
			addbill.ShowDialog();

			paypermonth = int.Parse(addbill.metroTextBoxppm.Text);

			string strdate = addbill.metroTextBoxyear.Text + "-" + addbill.metroComboBoxmonth.Text;
			Bill temp = new Bill(strdate, false);
			bills.Add(temp);

			FireBase.UpdateBillList(bills, metroTextBoxsearch.Text);

			metroButton1_Click(sender, e);
		}

        private void metroButtondelete_Click(object sender, EventArgs e)
        {
			bills.Remove(bills.Find(x => x.date == bill.date));
			FireBase.UpdateBillList(bills, metroTextBoxsearch.Text);
			metroButton1_Click(sender, e);
		}
    }
}
