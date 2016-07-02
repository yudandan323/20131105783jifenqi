//
//  ViewController.swift
//  计分器
//
//  Created by 于丹丹 on 16/4/25.
//  Copyright © 2016年 于丹丹. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var laoying: UIImageView!
    @IBOutlet var qishi: UIImageView!
    var db:SQLiteDB!
    


    var timer:NSTimer!
    var x=0
    var y=0
    
    var fen=12
    var miao=0
    
    
    @IBOutlet var Ascore: UILabel!
    
    @IBOutlet var sec: UILabel!
    @IBOutlet var min: UILabel!
   
    @IBOutlet var Bscore: UILabel!
    @IBAction func A3(sender: UIButton) {
        x=x+3
        Ascore.text=String(x)
        saveUser()
    }
    @IBAction func A2(sender: UIButton) {
        x=x+2
        Ascore.text=String(x)
        saveUser()
    }
    @IBAction func A1(sender: UIButton) {
        x=x+1
        Ascore.text=String(x)
        saveUser()
    }
    @IBAction func B3(sender: UIButton) {
        y=y+3
        Bscore.text=String(y)
        saveUser()
    }
    @IBAction func B2(sender: UIButton) {
        y=y+2
        Bscore.text=String(y)
        saveUser()
    }
    @IBAction func B1(sender: UIButton) {
        y=y+1
        Bscore.text=String(y)
        saveUser()
    }
    
    @IBAction func start(sender: UIButton) {
        timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1),target:self,selector:Selector("tickDown"),
            userInfo:nil,repeats:true)
    }
    @IBAction func reaction(sender: UIButton) {
        Ascore.text="0"
        Bscore.text="0"
        timer?.invalidate();
        min.text="12"
        sec.text="00"
        
    }
    @IBAction func stop(sender: UIButton) {
        timer.invalidate();
    }
    @IBAction func con(sender: UIButton) {
        timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1),target:self,selector:Selector("tickDown"),
            userInfo:nil,repeats:true)
    }
    func tickDown()
    {
        min.text=String(fen)
        sec.text=String(miao)
        if(fen != 0 && miao == 0)
        {
            fen=fen-1
            miao=60
        }
        miao = miao-1
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        //获取数据库实例
        db = SQLiteDB.sharedInstance()
        //如果表还不存在则创建表（其中uid为自增主键）
        db.execute("create table if not exists score(uid integer primary key,Ascore varchar(20),Bscore varchar(20))")
        //如果有数据则加载
        initUser()
        min.text="12"
        sec.text="00"
        
    }
    
    //点击保存
    
    //从SQLite加载数据
    func initUser() {
        let data = db.query("select * from score")
        if data.count > 0 {
            //获取最后一行数据显示
            let user = data[data.count - 1]
            Ascore.text = user["Ascore"] as? String
            Bscore.text = user["Bscore"] as? String
        }
    }
    
    //保存数据到SQLite
    func saveUser() {
        let Ascore = self.Ascore.text!
        let Bscore = self.Bscore.text!        //插入数据库，这里用到了esc字符编码函数，其实是调用bridge.m实现的
        let sql = "insert into score(Ascore,Bscore) values('\(Ascore)','\(Bscore)')"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql)
        print(result)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

