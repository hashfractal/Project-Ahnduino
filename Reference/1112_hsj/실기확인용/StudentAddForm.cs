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
    public partial class StudentAddForm : Form
    {
        public int Number    { get { return int.Parse(textBox1.Text); }}
        public string StuName   { get { return textBox2.Text; } }
        public string Subject   { get { return comboBox1.SelectedItem.ToString(); } }
        public int Grade        { get { return comboBox2.SelectedIndex + 1; } }

        public StudentAddForm()
        {
            InitializeComponent();
        }

        public Student GetStudentInfo()
        {
            return new Student(Number, StuName, Subject, Grade);
        }

        private void button3_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
            this.Close();
        }
    }
}
