docker-mysql
============

### Create MySQL data container
    docker run -d --name mysql_data mysql_data

### Run MySQL container
    docker run -d --volumes-from mysql_data --name mysql -p 3306:3306 mysql
