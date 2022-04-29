using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace _1112_hsj
{
    public partial class Form1 : Form
    {
        private StuManager sm = StuManager.Singleton;
        public Form1()
        {
            InitializeComponent();        
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            PrintStudent();
        }
  
        //메뉴-파일>>프로그램종료
        private void 프로그램종료XToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        //메뉴-도움말>>프로그램정보
        private void 프로그램종료FToolStripMenuItem_Click(object sender, EventArgs e)
        {
            MessageBox.Show("WinForm실기\r\n허세진\r\n2021-11-12");
        }

        #region 기능

        //전체출력
        private void PrintStudent()
        {
            listView1.Items.Clear();

            label1.Text = string.Format("총 학생수 : {0}명", sm.PrintAll().Count);
            foreach (Student s in sm.PrintAll())
            {
                listView1.Items.Add(new ListViewItem(new string[]
                { s.Number.ToString(), s.Name, s.Subject, s.Grade.ToString() }));
            }
        }

        //입력
        private void 회원정보입력ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            StudentAddForm form = new StudentAddForm();
            if (form.ShowDialog() == DialogResult.OK)
            {
                Student stu = form.GetStudentInfo();
                if (sm.InsertStudent(stu.Number, stu.Name, stu.Subject, stu.Grade) == false)
                    MessageBox.Show("저장 실패");
                else
                    PrintStudent();
            }
        }

        //검색
        private void listView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listView1.SelectedItems.Count != 0)
            {
                int number = int.Parse(listView1.SelectedItems[0].Text);
                PrintStudentInfo(number);
            }  
        }

        private void button1_Click(object sender, EventArgs e)
        {
            int number = int.Parse(textBox1.Text);
            PrintStudentInfo(number);
        }

        private void PrintStudentInfo(int number)
        {
            Student stu = sm.NumberToStudent(number);
            if(stu == null)
            {
                MessageBox.Show("없는 학번입니다.");
                return;
            }

            textBox1.Text = stu.Number.ToString();
            textBox2.Text = stu.Name;

            if (stu.Subject == "컴퓨터") comboBox1.SelectedIndex = 0;
            else if (stu.Subject == "IT") comboBox1.SelectedIndex = 1;
            else if (stu.Subject == "게임") comboBox1.SelectedIndex = 2;
            else comboBox1.SelectedIndex = 3;

            comboBox2.SelectedIndex = stu.Grade - 1;
        }

        //삭제
        private void button2_Click(object sender, EventArgs e)
        {
            int number = int.Parse(textBox1.Text);
            if (sm.DeleteStudent(number) == true)
                PrintStudent();
            else
                MessageBox.Show("없는 학번입니다.");
        }

        //수정
        private void button3_Click(object sender, EventArgs e)
        {
            int number = int.Parse(textBox1.Text);

            string subject = null;
            switch(comboBox1.SelectedIndex)
            {
                case 0: subject = "컴퓨터"; break;
                case 1: subject = "IT"; break;
                case 2: subject = "게임"; break;
                case 3: subject = "기타"; break;
            }

            int grade = comboBox2.SelectedIndex + 1;

            if (sm.UpdateStudent(number, subject, grade) == true)
                PrintStudent();
            else
                MessageBox.Show("수정 실패");
        }

        #endregion
    }
}
