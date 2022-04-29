using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _1112_hsj
{
    /// <summary>
    /// Member 데이터 클래스
    /// </summary>
    public class Student
    {
        private readonly int number;
        private string name;
        private string subject;
        private int grade; 
        
        public int Number { get { return number;  } }
        public string Name { get { return name; } set { name = value; } }
        public string Subject { get { return subject; } set { subject = value; } }
        public int Grade
        {
            get { return grade; }
            set {
                if (value < 1 || value > 4)
                    throw new Exception("해당 학년은 존재하지 않습니다.");
                grade = value;
            }
        }

        public Student() { }
        public Student(int _number, string _name, string _subject, int _grade)
        {
            number = _number;
            Name = _name;
            Subject = _subject;
            Grade = _grade;
        }

        public override string ToString()
        {
            return Number + ", " + Name + ", " + Subject + ", " + Grade;
        }

        public void Print()
        {
            Console.WriteLine("학번 : " + Number);
            Console.WriteLine("이름 : " + Name);
            Console.WriteLine("학과 : " + Subject);
            Console.WriteLine("학년 : " + Grade);
        }
    }
}
