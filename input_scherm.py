"""
Auteur: Arlet CULHACI
Date: 13122018
Version: Python3.*
Subject: Input screen pipeline
"""
from tkinter import *
from tkinter import filedialog
from tkinter import messagebox
class Window(Frame):

    def __init__(self, master=None):
        Frame.__init__(self, master)                 
        self.master = master
        self.init_window()

    #Creation of init_window
    def init_window(self):

        # changing the title of our master widget      
        self.master.title("STACKS")

        # allowing the widget to take the full space of the root window
        self.pack(fill=BOTH, expand=1)
        def exe():
            renzym  = varx.get()
            truncate = e.get()
            score = e2.get()
            window_size = w.get()   
            depth = v.get()
            mm = z.get()
            msec = x.get()
            mother = eMother.get()
            father = eFather.get()
            if (truncate == ""):
                truncate = "140"
            if (score == ""):
                score = "20"
            print("-r" + renzym)
            print("-t" + truncate)
            print("-s" + score)
            print("-w" + window_size)
            print("-d" + depth)
            print("-m" + mm)
            print("-n" + msec)
            print("-y" + father)
            print("-x" + mother)
            if (str(var1.get()) == "2"):
                button_genome.place(x = 300 , y=50)
                print("ref")
            if (str(var1.get()) == "1"):
                button_genome.place_forget()
                print("novo")
            if (str(var2.get()) == "2"):
                button_file1.place(x = 0 , y=200)
                button_file2.place(x = 300 , y=200)
                print("paired")
            if (str(var2.get()) == "1"):
                button_file2.place_forget()
                button_file1.place(x = 0 , y=200)
                print("single")
            #tkinter.messageBox.showwarning("Warning","Warning message")
            exit()
        def quit():
            exit()
        def sel():
            if (str(var1.get()) == "2"):
                button_genome.place(x = 300 , y=50)
                #print("ref")
            if (str(var1.get()) == "1"):
                button_genome.place_forget()
                labl_genome.place_forget()
                #print("novo")
        def sel3():
            if (str(var2.get()) == "2"):
                button_file1.place(x = 0 , y=200)
                button_file2.place(x = 300 , y=200)
                #print("paired")
            if (str(var2.get()) == "1"):
                button_file2.place_forget()
                button_file1.place(x = 0 , y=200)
                #print("single")
        def sel2():
            if (str(var3.get()) == "2"):
                p.place_forget()
                labl_renzym.place_forget()
                e.place_forget()
                e2.place_forget()
                w.place_forget()
                v.place_forget()
                z.place_forget()
                x.place_forget()
            elif (str(var3.get()) == "1"):
                labl_renzym.place(x = 250, y= 400)
                p.place(x= 250, y=450)
                #labl_truncate = Label(self, text="Choose your restriction enzyme")
                #labl_truncate(x = 300, y= 600)   
                #labl_score = Label(self, text="Choose your restriction enzyme")
                #labl_score(x = 500, y= 600) 
                e.place(x = 250, y=550) 
                e2.place(x = 350, y=450) 
                w.place(x = 350, y=500)
                v.place(x = 350, y=550)
                z.place(x = 350, y=600)
                x.place(x = 350, y=650)
                #text = e.get()
        def browse_button_file1():
            # Allow user to select a directory and store it in global var
            # called folder_path
            #global folder_path
            filename = filedialog.askopenfilename()
            print(filename)
            filename_formatted = filename.split("/")
            labl_file = Label(self, text=filename_formatted[-1])
            labl_file.place(x=0, y=225)
        def browse_button_file2():
            # Allow user to select a directory and store it in global var
            # called folder_path
            #global folder_path
            filename = filedialog.askopenfilename()
            print(filename)
            filename_formatted = filename.split("/")
            labl_file2 = Label(self, text=filename_formatted[-1])
            labl_file2.place(x=300, y=225)
            #print(filename)
        def browse_button_genome():
            # Allow user to select a directory and store it in global var
            # called folder_path
            #global folder_path
            filename = filedialog.askdirectory()
            print("-g" + filename)
            filename_formatted = filename.split("/")
            labl_genome = Label(self, text=filename_formatted[-1])
            labl_genome.place(x=350, y=50)
            #print(filename)
        def browse_button_barcode():
            # Allow user to select a directory and store it in global var
            # called folder_path
            #global folder_path
            filename = filedialog.askopenfilename()
            print(filename)
            filename_formatted = filename.split("/")
            labl_file = Label(self, text=filename_formatted[-1])
            labl_file.place(x=100, y=325)
        def browse_button_popmap():
            # Allow user to select a directory and store it in global var
            # called folder_path
            #global folder_path
            filename = filedialog.askopenfilename()
            print(filename)
            filename_formatted = filename.split("/")
            labl_file = Label(self, text=filename_formatted[-1])
            labl_file.place(x=200, y=325)
        def browse_dir():
            dirname = filedialog.askdirectory()
            print("-f" + dirname)
            dirname_formatted = dirname.split("/")
            labl_file = Label(self, text=dirname_formatted[-1])
            labl_file.place(x=0, y=325)


        # creating a button instance
        #genome_path = ""
        #file1_path = ""
        #file2_path = ""
        #output_dir = ""
        #barcode_dir = ""
        #pop_dir = ""
        #renzym = "SbfI"
        #truncate = "140"
        #score = "20"
        #window_size = "0.13"
        #depth = "3"
        #mm = "2"
        #msec = "1"
        labl_genome = Label(self, text="")
        button_file1 = Button(text="Browse", command=browse_button_file1)
        button_file2 = Button(text="Browse", command=browse_button_file2)
        button_file1.place(x = 0 , y=200)
        button_genome = Button(text="Browse", command=browse_button_genome)
        var1 = StringVar()
        var2 = StringVar()
        var3 = StringVar()
        var1.set(1)
        var2.set(1)
        var3.set(2)
        varx = StringVar()
        varx.set('sbfI')
        p = OptionMenu(root, varx, 'aciI', 'ageI', 'aluI', 'apaLI', 'apeKI', 'apoI', 'aseI', 'bamHI', 'bbvCI', 'bfaI', 'bfuCI', 'bgIII', 'bsaHI', 'bspDI', 'bstYI')
        #p.pack()
        #e2.pack()
        var_wind  = StringVar()
        var_wind.set("0.13")
        #w = Spinbox(root, from_=0, to=1, textvariable=var_wind )
        w = Spinbox(root, format="%.2f",from_=0, to=1, increment=0.01, textvariable=var_wind) 
        #w.pack()
        var_truncate = StringVar()
        var_truncate.set("140")
        e = Entry(root, text="Truncate lenght", width=20, textvariable=var_truncate)
        #e.pack()
        var_phred = StringVar()
        var_phred.set("20")
        e2 = Entry(root, text="Phred score", width=20, textvariable=var_phred)

        var_dep = StringVar()
        var_dep.set("3")
        v = Spinbox(root, from_=0, to=10,textvariable=var_dep )
        #v.pack()
        var_mm = StringVar()
        var_mm.set("2")
        z = Spinbox(root, from_=0, to=20, textvariable=var_mm)
        #z.pack()
        var_sec = StringVar()
        var_sec.set("1")
        x = Spinbox(root, from_=0, to=5, textvariable=var_sec)
        #x.pack()
        var_father = StringVar()
        var_father.set("")
        eFather = Entry(root, text="", width=20, textvariable=var_father)

        var_mother = StringVar()
        var_mother.set("")
        eMother = Entry(root, text="", width=20, textvariable=var_mother)
        labl_father = Label(self, text="Father")
        labl_mother = Label(self, text="Mother")
        labl_renzym = Label(self, text="Choose your restriction enzyme")
        quitButton = Button(self, text="Quit", command= quit, activeforeground='red')
        labl_analysis = Label(self, text="Choose your data analyis type")
        labl_data = Label(self, text="Choose your data type")
        labl_outdir = Label(self, text="Ouput directory")
        labl_barcodes = Label(self, text="Barcode file")
        labl_popmap_file = Label(self, text="Popmap file")
        labl_param = Label(self, text="Change the default parameters?")
        R1 = Radiobutton(root, text="De novo", variable=var1, value=1,command=sel)
        R1.pack( anchor = W )
        R2 = Radiobutton(root, text="Reference based", variable=var1, value=2,command=sel)
        R2.pack( anchor = W )
        R3 = Radiobutton(root, text="Single-end", variable=var2, value=1,command=sel3)
        R3.pack( anchor = W )
        R4 = Radiobutton(root, text="Paired-end", variable=var2, value=2,command=sel3)
        R4.pack( anchor = W )
        R5 = Radiobutton(root, text="Yes", variable=var3, value=1,command=sel2)
        R5.pack( anchor = W )
        R6 = Radiobutton(root, text="No", variable=var3, value=2,command=sel2)
        R6.pack( anchor = W )
        SubmitButton = Button(self, text="Submit",command=exe)
        folder_path = StringVar()
        lbl1 = Label(master=root,textvariable=folder_path)
        button2 = Button(text="Browse", command=browse_dir)
        button3 = Button(text="Browse", command=browse_button_barcode)
        #button4 = Button(text="Browse", command=browse_button_popmap)
        button5 = Button(text="Browse", command=browse_button_popmap)
        # placing the button on my window
        labl_analysis.place(x=0, y=0)
        R1.place(x=0, y=50)
        R2.place(x=150, y=50)
        labl_data.place(x=0, y=100)
        R3.place(x=0, y=150)
        R4.place(x=150, y=150)
        #quitButton.place(x=660, y=670)
        SubmitButton.place(x=20, y=500)
        button2.place(x = 0, y=300)
        labl_outdir.place(x = 0, y = 250)
        labl_barcodes.place(x  = 150, y = 250)
        labl_popmap_file.place(x = 250, y=250)
        labl_father.place(x = 350, y=250)
        labl_mother.place(x=550, y=250)
        button3.place(x = 150, y=300)
        eFather.place(x = 350, y=305)
        eMother.place(x = 550, y=305)
        #button4.place(x = 250, y=300)
        button5.place(x = 250, y=300)
        labl_param.place(x = 0, y=350)
        R5.place(x=0, y=400)
        R6.place(x=150, y=400)
root = Tk()

#size of the window
root.geometry("760x760")
label = Label(root)
label.pack()
app = Window(root)
root.mainloop()  
