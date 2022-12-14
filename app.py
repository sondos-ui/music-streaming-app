import os

from flask import request,session,Flask , render_template, sessions, url_for
from flask.helpers import redirect
from flask.wrappers import Request

import mysql.connector
from mysql.connector.cursor import MySQLCursor



##############################DATABASE CONNECTION##############################
dp=mysql.connector.connect(
    host="localhost",user="root",passwd="moaz2008",database="musicplayer");
 
mycursor=dp.cursor()

app=Flask(__name__)

app.secret_key="seckeyy"



##############################INDEX PAGE##############################

@app.route('/')
def index():
    return render_template('index.html')
@app.route('/logout')
def logout():
    session.pop('username',None)
    session.pop('diaplay_name',None)
    session.pop('loggedin',None)
    session.pop('playlists',None)
    return redirect(url_for('index'))


##############################LOGIN PAGE##############################

@app.route('/login', methods=['GET','POST'])
def login():
    msg=''
    if request.method=='POST':
        username=request.form['username']
        password=request.form['password']
        mycursor.execute("select * from user where username=%s AND password=%s",(username,password))
        record=mycursor.fetchone()
        if record:
            session['loggedin']=True
            session['username']=record[0]
            session['display_name']=record[4]
            return redirect(url_for('home'))
        else:
            msg="incorrect username or password."
        return render_template('index.html',msg=msg)



##############################SIGNUP PAGE##############################

@app.route("/signup",methods=['GET','POST'])
def signup():

    msg=""
    if request.method == 'POST' and 'email' in request.form :
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']
        displayName=request.form['displayName']
        age=request.form['age']
        gender=request.form['gender']
        mycursor.execute("SELECT * FROM user WHERE username=%s",(username,))
        record=mycursor.fetchone()
        if record: 
            msg="choose another user name"
            return render_template("signup.html",msg=msg)
        mycursor.execute("SELECT * FROM user WHERE email=%s",(email,))
        record=mycursor.fetchone()
        if record: 
            msg="this email is already registered"
            return render_template("signup.html",msg=msg)
        mycursor.execute('INSERT INTO user VALUES (%s, %s, %s, %s,%s,%s)', (username, email, password,gender,displayName,age ))
        dp.commit()
        session['loggedin']=True
        session['username']=username
        session['display_name']=diaplayName
        return  redirect(url_for('home'))
    msg="please fill the form information"
    return render_template("signup.html",msg=msg)




##############################HOME PAGE##############################

@app.route("/home")
def home():
    mycursor.execute("SELECT path FROM track")
    songs=mycursor.fetchall()
    mycursor.execute("SELECT playlistID,title FROM playlist")
    playlist_data=mycursor.fetchall()
    session['playlists']=playlist_data
    return render_template('home.html',username=session['display_name'],songs=songs,playlist_data=playlist_data)


##############################MYSONGS FUNCTION##############################

@app.route('/mySongs')
def mySongs():
    mycursor.execute("SELECT path FROM track where trackOwner=%s",(session['username'],))
    songs=mycursor.fetchall()
    return render_template('home.html',username=session['username'],songs=songs,playlist_data=session['playlists'])


##############################MYLIKES FUNCTION##############################

@app.route('/myLikes')
def myLikes():
    mycursor.execute("SELECT path FROM track as t WHERE t.trackID IN (SELECT trackID FROM likes where userName=%s) ",(session['username'],))
    songs=mycursor.fetchall()
    return render_template('home.html',username=session['username'],songs=songs,playlist_data=session['playlists'])



##############################UPLOAD TRACK PAGE##############################

app.config["track_dir"]="G://lectures/soundstreaming app/static/tracks"

def allowed_ext(filename):
    if not '.' in filename:
        return False
    ext=filename.rsplit('.',1)[1]
    if ext.upper() =='MP3':
        return True
    else: return False


@app.route('/upload',methods=['GET','POST'])
def upload():
    if request.method=='POST':
        if request.files:
            track=request.files['track']
            if not allowed_ext(track.filename):
                return render_template('upload.html',msg="please select .MP3 file")
            track_title=request.form['title']
            track.save(os.path.join(app.config["track_dir"],track_title+'.mp3'))
            mycursor.execute("INSERT INTO track (title,path,trackOwner) VALUES (%s,%s,%s)",(track_title,"tracks/"+track_title+".mp3",session['username']) )
            dp.commit()
            return redirect(url_for('home'))
    return render_template("upload.html")
    
##############################CHOOSEPLAYLIST FUNCTION##############################

@app.route('/choosePlaylist',methods=['GET','POST'])
def choosePlaylist():
    idp=request.args.get('type')
   
    mycursor.execute("SELECT path FROM track as t WHERE t.trackID in (SELECT trackID FROM contains WHERE playlistID=%s)",(idp,))
    songs=mycursor.fetchall()
    return render_template('home.html',username=session['username'],songs=songs,playlist_data=session['playlists'])


##############################CREATEPLAYLIST FUNCTION##############################

@app.route('/createPlaylist',methods=['GET','POST'])
def createPlaylist():
    if request.method=='POST':
        title=request.form['playlist_title']
        mycursor.execute("INSERT INTO playlist (title,playlistOwner) VALUES (%s,%s)",(title,session['username']))
        dp.commit()
        return redirect(url_for('managePlaylists'))
   
    return render_template('create playlist.html')



##############################MANAGE FOLLOWERS PAGE##############################

@app.route('/manageFollowers')
def manageFollowers():
    mycursor.execute(" select userName from follows_user where following=%s and userName in(select following from follows_user where userName=%s)",(session['username'],session['username']))
    mu_users=mycursor.fetchall()
    mycursor.execute(" select userName from follows_user where following=%s and userName not in(select following from follows_user where userName=%s)",(session['username'],session['username']))
    f_users=mycursor.fetchall()
    return render_template('manage followers.html',mu_users=mu_users,f_users=f_users,username=session['display_name'])


@app.route('/unfollowUser',methods=['GET','POST'])
def unfollowUser():
    f_id=request.args.get('type')
    mycursor.execute("DELETE FROM follows_user WHERE userName=%s and following=%s",(session['username'],f_id))
    dp.commit()
    return redirect(url_for('manageFollowers'))



@app.route('/followUser',methods=['GET','POST'])
def followUser():
    f_id=request.args.get('type')
    mycursor.execute("insert into follows_user values(%s,%s)",(session['username'],f_id))
    dp.commit()
    return redirect(url_for('manageFollowers'))



##############################FOLLOWING PAGE##############################


@app.route('/manageFollowings')
def manageFollowings():
    mycursor.execute(" select following from follows_user where  userName=%s",(session['username'],))
    f_users=mycursor.fetchall()
    mycursor.execute(" select userName from user where userName!=%s and userName not in( select following from follows_user where  userName=%s)",(session['username'],session['username']))
    df_users=mycursor.fetchall()
    return render_template('manage followings.html',f_users=f_users,df_users=df_users,username=session['display_name'])

@app.route('/unfollowUser2',methods=['GET','POST'])
def unfollowUser2():
    f_id=request.args.get('type')
    mycursor.execute("DELETE FROM follows_user WHERE userName=%s and following=%s",(session['username'],f_id))
    dp.commit()
    return redirect(url_for('manageFollowings'))



@app.route('/followUser2',methods=['GET','POST'])
def followUser2():
    f_id=request.args.get('type')
    mycursor.execute("insert into follows_user values(%s,%s)",(session['username'],f_id))
    dp.commit()
    return redirect(url_for('manageFollowings'))


##############################MANAGETRACKS AND LIKES PAGE##############################


@app.route('/manageTracks')
def manageTracks():
    mycursor.execute(" select title,trackID from track where trackID in (select trackID from likes where userName=%s)",(session['username'],))
    l_tracks=mycursor.fetchall()
    mycursor.execute(" select title,trackID from track where trackID not in (select trackID from likes where userName=%s)",(session['username'],))
    dis_tracks=mycursor.fetchall()
    mycursor.execute("SELECT title, trackID FROM track WHERE trackOwner=%s",(session['username'],))
    my_tracks=mycursor.fetchall()
    return render_template('manage tracks.html',my_tracks=my_tracks,l_tracks=l_tracks,dis_tracks=dis_tracks,username=session['display_name'])

@app.route('/dislikeSong',methods=['GET','POST'])
def dislikeSong():
    s_id=request.args.get('type')
    mycursor.execute("DELETE FROM likes WHERE trackID=%s and userName=%s",(s_id,session['username']))
    dp.commit()
    return redirect(url_for('manageTracks')) 

@app.route('/likeSong',methods=['GET','POST'])
def likeSong():
    s_id=request.args.get('type')
    mycursor.execute("SELECT trackOwner FROM track WHERE trackID=%s ",(s_id,))
    s_owner=mycursor.fetchone()
    mycursor.execute("INSERT INTO likes (trackID,userName,trackOwner)VALUES(%s,%s,%s)",(s_id,session['username'],s_owner[0]))
    dp.commit()
    return redirect(url_for('manageTracks'))

@app.route('/delTrack',methods=['GET','POST'])
def delTrack():
    t_id=request.args.get('type')
    mycursor.execute("DELETE FROM track WHERE trackID=%s AND trackOwner=%s",(t_id,session['username']))
    dp.commit()
    return redirect(url_for('manageTracks'))




##############################MANAGE PLAYLISTS PAGE##############################


@app.route('/managePlaylists')
def managePlaylists():
    mycursor.execute("SELECT p.title,p.playlistID FROM playlist as p join follows_playlist as f on p.playlistID=f.playlistID  WHERE f.userName=%s",(session['username'],))
    f_lists=mycursor.fetchall()
    mycursor.execute("select title, playlistID from playlist where playlistID not in(select playlistID from follows_playlist where userName=%s)",(session['username'],))
    un_lists=mycursor.fetchall()
    mycursor.execute("SELECT title,playlistID FROM playlist  WHERE playlistOwner=%s",(session['username'],))
    user_lists=mycursor.fetchall()
   
    return render_template('manage playlists.html',f_lists=f_lists,un_lists=un_lists,user_lists=user_lists,username=session['display_name'])
   
@app.route('/followPlaylist',methods=['GET','POST'])
def followPlaylist():
    p_id=request.args.get('type')
    mycursor.execute("SELECT playlistOwner FROM playlist WHERE playlistID=%s ",(p_id,))
    p_owner=mycursor.fetchone()
    mycursor.execute("INSERT INTO follows_playlist (playlistID,userName,playlistOwner)VALUES(%s,%s,%s)",(p_id,session['username'],p_owner[0]))
    dp.commit()
    return redirect(url_for('managePlaylists'))
  
@app.route('/unfollowPlaylist',methods=['GET','POST'])
def unfollowPlaylist():
    p_id=request.args.get('type')
    mycursor.execute("DELETE FROM follows_playlist WHERE playlistID=%s AND userName=%s",(p_id,session['username']))
    dp.commit()
    return redirect(url_for('managePlaylists'))

@app.route('/delPlaylist',methods=['GET','POST'])
def delPlaylist():
    p_id=request.args.get('type')
    mycursor.execute("DELETE FROM playlist WHERE playlistID=%s AND playlistOwner=%s",(p_id,session['username']))
    dp.commit()
    return redirect(url_for('managePlaylists'))




if __name__=="__main__":
    app.run(debug=True)
