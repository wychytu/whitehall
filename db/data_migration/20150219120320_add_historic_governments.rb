governments = [
  ["2010 to 2015 Conservative and Liberal democrat coalition government", "2010-05-12"]
  ["2005 to 2010 Labour government","2005-05-06","2010-05-11"],
  ["2001 to 2005 Labour government","2001-06-08","2005-05-05"],
  ["1997 to 2001 Labour government","1997-05-02","2001-06-07"],
  ["1992 to 1997 Conservative government","1992-04-10","1997-05-01"],
  ["1987 to 1992 Conservative government","1987-06-12","1992-04-09"],
  ["1983 to 1987 Conservative government","1983-06-10","1987-06-11"],
  ["1979 to 1983 Conservative government","1979-05-04","1983-06-09"],
  ["1974 to 1979 Labour government","1974-10-11","1979-05-03"],
  ["1974 to 1974 Labour (minority) government","1974-03-04","1974-10-10"],
  ["1970 to 1974 Conservative government","1970-06-19","1974-03-03"],
  ["1966 to 1970 Labour government","1966-04-01","1970-06-18"],
  ["1964 to 1966 Labour government","1964-10-16","1966-03-31"],
  ["1959 to 1964 Conservative government","1959-10-09","1964-10-15"],
  ["1955 to 1959 Conservative government","1955-05-27","1959-10-08"],
  ["1951 to 1955 Conservative government","1951-10-26","1955-05-26"],
  ["1950 to 1951 Labour government","1950-02-24","1951-10-25"],
  ["1945 to 1950 Labour government","1945-07-27","1950-02-23"],
  ["1935 to 1945 National government","1935-11-15","1945-07-26"],
  ["1931 to 1935 National government","1931-10-28","1935-11-14"],
  ["1929 to 1931 Labour (minority) government","1929-05-30","1931-10-27"],
  ["1924 to 1929 Conservative government","1924-10-29","1929-05-29"],
  ["1923 to 1924 Labour (minority) government","1923-12-06","1924-10-28"],
  ["1922 to 1923 Conservative government","1922-11-15","1923-12-05"],
  ["1918 to 1922 Conservative and Liberal coalition government","1918-12-14","1922-11-14"],
  ["1910 to 1918 Liberal (minority) government","1910-12-19","1918-12-13"],
  ["1910 to 1910 Liberal (minority) government","1910-02-10","1910-12-18"],
  ["1906 to 1910 Liberal government","1906-02-08","1910-02-09"],
  ["1900 to 1906 Conservative government","1900-10-24","1906-02-07"],
  ["1895 to 1900 Conservative government","1895-08-07","1900-10-23"],
  ["1892 to 1895 Liberal (minority) government","1892-07-26","1895-08-06"],
  ["1886 to 1892 Conservative government","1886-07-27","1892-07-25"],
  ["1885 to 1886 Liberal (minority) government","1885-12-18","1886-07-26"],
  ["1880 to 1885 Liberal government","1880-04-27","1885-12-17"],
  ["1874 to 1880 Conservative government","1874-02-17","1880-04-26"],
  ["1868 to 1874 Liberal government","1868-12-07","1874-02-16"],
  ["1865 to 1868 Liberal government","1865-07-24","1868-12-06"],
  ["1859 to 1865 Liberal government","1859-05-18","1865-07-23"],
  ["1857 to 1859 Whig government","1857-04-24","1859-05-17"],
  ["1852 to 1857 Conservative government","1852-07-31","1857-04-23"],
  ["1847 to 1852 Whig government","1847-08-26","1852-07-30"],
  ["1841 to 1847 Conservative government","1841-07-22","1847-08-25"],
  ["1837 to 1841 Whig government","1837-08-18","1841-07-21"],
  ["1835 to 1837 Whig government","1835-04-08","1837-08-17"],
  ["1833 to 1835 Whig government","1833-01-29","1835-04-07"],
  ["1831 to 1833 Whig government","1831-06-14","1833-01-28"],
  ["1830 to 1831 Whig government","1830-09-14","1831-06-13"],
  ["1826 to 1830 Tory government","1826-07-25","1830-09-13"],
  ["1820 to 1826 Tory government","1820-04-21","1826-07-24"],
  ["1818 to 1820 Tory government","1818-08-04","1820-04-20"],
  ["1812 to 1818 Tory government","1812-11-24","1818-08-03"],
  ["1807 to 1812 Tory government","1807-06-22","1812-11-23"],
  ["1806 to 1807 Whig government","1806-12-13","1807-06-21"],
  ["1802 to 1806 Tory government","1802-08-31","1806-12-12"],
  ["1801 to 1802 Tory government","1801-01-22","1802-08-30"]
]
governments.each do |name, start_date, end_date|
  Government.create(name: name, start_date: start_date, end_date: end_date)
end
