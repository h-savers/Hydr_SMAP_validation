function ok = text2pdf(filename,t_text,show_pdf)
%
% Creation of a text-based pdf [version 03, 2013]
%
% ok = text2pdf(filename,t_text,show_pdf)
%       filename -> name of the pdf, can include the path
%       t_text   -> text cell: row 1 is the title, row 2 the first line of the text, etc...
%       show_pdf -> boolean, 1 -> opens the default pdf viewer with the file
%                   be careful, some pdf viewers do not update automatically a modified file
%       ok =  1  -> pdf created successfully
%       ok =  0  -> pdf structure creation failed
%       ok = -1  -> cannot create a file with this filename
%       ok = -2  -> pdf created successfully but not properly viewed
%
% Example:
%
% ok = text2pdf('test.pdf',{'Title text';'Line 1: comments';'Line 2: comments'})


% Code by by Jordi Palacin, http://robotica.udl.cat
%
% Inpsired in the web-explanation of Alex McCormack
% http://www.amccormack.net/anatomy-of-a-pdf-document/

if (nargin == 0)
    % default filename
    filename = 'test.pdf';
    
    % default text
    t_text = {'Title text';...
         'Line 1: comments';
         'Line 2: comments'};
    
    % show the pdf
    show_pdf = 1;
    
elseif (nargin == 1)
    % default text
    t_text = {'Title text';...
         'Line 1: comments';
         'Line 2: comments'};
     
    % show the pdf
    show_pdf = 1;
    
elseif (nargin == 2)
    % show the pdf
    show_pdf = 1;
    
end

% number of text lines
if iscell(t_text)
    n_lines = length(t_text);
else
    % convert to cell
    a{1} = t_text;
    t_text = a;
    
    n_lines = 1;
end

try
    % open the file
    if isempty(strfind(filename,'.pdf'))
        filename = [filename '.jpg'];
    end
    
    fid = fopen(filename,'w');
    if (fid == -1)
        disp(' ');
        disp(['Warning: fopen cannot create the file ' filename ', try to close the file or the pdf viewer.']);
        disp(' ');
        % error
        if (nargout == 1)
            ok = -1;
        end
        return;
    end
        
    c = 0;  % byte counter

    % Most of the comments are copied directly from the web-explanation
    % http://www.amccormack.net/anatomy-of-a-pdf-document/

    % This is the one line header section and all it does is declare the file as a PDF file of version 1.7.
    c = c + fprintf(fid,'%%PDF-1.7\r\n\r\n');

    % Next we have the body of the PDF document.
    % The body is a sequence of objects that make up the document.
    % There are 8 types of objects and each one listed in the body is an indirect object.
    % An indirect object is a labelled object, so that it may be called by other objects.
    % The body of the PDF document is made up of dictionary objects.
    % A dictionary object is an associative table containing pairs of objects (known as entries) represented by a key and a value.
    % The key must be a name and the value may be of any kind (including another dictionary).
    % The keys in a single dictionary must be unique.
    % A dictionary is written as a sequence of key-value pairs enclosed in double angle brackets (<<) and (>>).

    % Lets take a look at the first object in our file:
    % An indirect object is defined as
    %   X Y obj ExampleObject endobj
    %   X is referred to as the object number
    %   Y is referred to as the generation number. The generation number refers to the generation (version) of the PDF document as PDF documents may be incrementally updated.
    % Lines between << and >> start and end the dictionary.
    % Lines between describes the type of the dictionary object.

    p(1) = c; % start of the object 1

    c = c + fprintf(fid,'1 0 obj\r\n');
    c = c + fprintf(fid,'<<\r\n');
    c = c + fprintf(fid,' /Type /Catalog\r\n');
    c = c + fprintf(fid,' /Outlines 2 0 R\r\n');
    c = c + fprintf(fid,' /Pages 3 0 R\r\n');
    c = c + fprintf(fid,'>>\r\n');
    c = c + fprintf(fid,'endobj\r\n\r\n');

    % We see that the type is a Catalog type.
    % This is a special (required) type and is the root of the document.
    % The catalog contains references to other objects defining the document’s contents, outlines, and other attributes.
    % A Catalog dictionary contains two required entires:
    %   Type always has a value of Catalog (by definition).
    %   Pages points to the object that is the root of the page tree. The page tree contains references to each page, and each page contains references to the content that makes up that page such as strings and images (see image above).

    % Outlines is an optional entry that references the root of the outline hierarchy.
    % The document outline consists of a tree-structured hierarchy of outline items (sometimes called bookmarks), which serve as a visual table of contents to display the documents structure to the user.
    % Since Outlines and Pages both reference indirect objects, we can see how they are described.
    % The value 2 0 R refers to an indirect object.
    % This is called an indirect reference.
    % The indirect reference consists of the object number, the generation number and the character R.

    % Lets look at the next object:

    p(2) = c; % start of the object 2

    c = c + fprintf(fid,'2 0 obj\r\n');
    c = c + fprintf(fid,'<<\r\n');
    c = c + fprintf(fid,' /Type /Outlines\r\n');
    c = c + fprintf(fid,' /Count 0\r\n');
    c = c + fprintf(fid,'>>\r\n');
    c = c + fprintf(fid,'endobj\r\n\r\n');

    % This describes the document outline object.
    % We see that this object has object number 2 and generation number 0.
    % In addition the dictionary is described as the Outlines type.
    % Count describes the total number of visible outline items at all levels of the outline.

    % Next we have object 3 which contains the dictionary for Pages, known as the Page Tree.

    p(3) = c; % start of the object 3

    c = c + fprintf(fid,'3 0 obj\r\n');
    c = c + fprintf(fid,'<<\r\n');
    c = c + fprintf(fid,' /Type /Pages\r\n');
    c = c + fprintf(fid,' /Kids [4 0 R]\r\n');
    c = c + fprintf(fid,' /Count 1\r\n');
    c = c + fprintf(fid,'>>\r\n');
    c = c + fprintf(fid,'endobj\r\n\r\n');

    % Page tree nodes are made up of the following:
    %   Type – (Required) which is always Pages for a page tree node.
    %   Parent – (Required – but it is prohibited in the root node) The page tree node that is the immediate parent of this one. We can tell that 3 is the root page tree node because it does not list a Parent entry.
    %   Kids – (Required) An array of indirect references to the immediate children of this node. In this case the node has 1 Kid and it is object 4.
    %   Count – (Required) The number of leaf nodes (page objects) that are descendants of this node within the page tree

    % This brings us to the page object. The source for our one page object is:

    p(4) = c; % start of the object 4

    % add all the contents of the page
    contents = '';
    for w=1:1:n_lines
        contents = [contents ' ' num2str(4+w) ' 0 R'];
    end

    c = c + fprintf(fid,'4 0 obj\r\n');
    c = c + fprintf(fid,'<<\r\n');
    c = c + fprintf(fid,' /Type /Page\r\n');
    c = c + fprintf(fid,' /Parent 3 0 R\r\n');
    c = c + fprintf(fid,' /MediaBox [0 0 594 792]\r\n');    % A4 size
    c = c + fprintf(fid,[' /Contents [' contents ']\r\n']);
    c = c + fprintf(fid,' /Resources\r\n');
    c = c + fprintf(fid,' <<\r\n');
    c = c + fprintf(fid,'  /ProcSet %d 0 R\r\n',5 + n_lines);   % the number object of the ProcSet
    c = c + fprintf(fid,'  /Font << /F1 %d 0 R >>\r\n',5 + n_lines + 1); % the number object of the Font
    c = c + fprintf(fid,' >>\r\n');
    c = c + fprintf(fid,'>>\r\n');
    c = c + fprintf(fid,'endobj\r\n\r\n');

    % The page object is a dictionary specifying the attributes of a single page of the document.
    % Lets discus the entries which have not been described previously.
    %   MediaBox – (Required, inheritable) – Includes a Rectangle Object which describes “bounding boxes” for the object.
    %   Contents (Optional) – A content stream that describe the contents of this page.
    %   Resources(Required, inheritable) – A dictionary containing any resources required by the page. Here we have two entries in resources: 
    %       ProcSet – References the object that describes the procedure sets
    %       Font – A dictionary that maps resource names to font dictionaries. In this case a font named F1 located in object 7.

    % Next we have object 5, which contains the content stream of our page.

    % The dictionary in this object describes only the length of the stream (within).
    % in this case = 31 (fix) + length of the positions (x) and (y) and the length of the (Text)

    % Next we see how the text is shown.
    % It should be noted that the Text uses operators and operands.
    % The operand (the object that is acted on) precedes the operator.
    % In mathematics, we see this with the square root operator. If 5^2 is written, we know that 5 (the operand) is to be squared (the operator).
    %   stream and endstream are the declaration for starting and ending the stream.
    %   BT and ET are the begin and end the text object.
    %   /F1 specifies the font and font size to use (the operand). Tf is the operator and specifies the name of the font resource, that is, an entry in the Font subdictionary of the current resource dictionary.
    %   100 700 specifies the starting position for the text on the page. Td is a text-positioning operator, and helps determine the location of the text.
    %   The String to be displayed is enclosed in parentheses. Tj takes a string operand and paints it using the font and other text related parameters.

    % the first line is the title at position 60, 720, fontsize 24
    x = num2str(60);
    y = num2str(720);

    p(5) = c; % start of the object 5

    l_text = char(t_text{1});

    c = c + fprintf(fid,'5 0 obj\r\n');
    c = c + fprintf(fid,['<< /Length %d >>\r\n'],31 + length(x) + length(y) + length(l_text));
    c = c + fprintf(fid,'stream\r\n');
    c = c + fprintf(fid,'BT\r\n');
    c = c + fprintf(fid,'/F1 24 Tf\r\n');
    c = c + fprintf(fid,[x ' ' y ' Td\r\n']);
    c = c + fprintf(fid,['(%s)Tj\r\n'],l_text);
    c = c + fprintf(fid,'ET\r\n');
    c = c + fprintf(fid,'endstream\r\n');
    c = c + fprintf(fid,'endobj\r\n\r\n');

    % the normal text lines start at object 6, position 60, 680, fontsize 12
    xx = 60;
    yy = 680;
    % distance between normal lines
    delta = 20;

    for w=2:1:n_lines
        x = num2str(xx);
        y = num2str(yy);

        p(4 + w) = c;

        l_text = char(t_text{w});

        c = c + fprintf(fid,'%d 0 obj\r\n',4+w);
        c = c + fprintf(fid,['<< /Length %d >>\r\n'],31 + length(x) + length(y) + length(l_text));
        c = c + fprintf(fid,'stream\r\n');
        c = c + fprintf(fid,'BT\r\n');
        c = c + fprintf(fid,'/F1 12 Tf\r\n');
        c = c + fprintf(fid,[x ' ' y ' Td\r\n']);   % coordinates
        c = c + fprintf(fid,['(%s)Tj\r\n'],l_text);
        c = c + fprintf(fid,'ET\r\n');
        c = c + fprintf(fid,'endstream\r\n');
        c = c + fprintf(fid,'endobj\r\n\r\n');

        % update yy for the next line
        yy = yy - delta;

        if (yy < 120)
            break;
        end
    end
    
    if isempty(w)
        % avoid problems if only entering the title
        w = 1;
    end
    
    % compute the current object number
    ww = 4 + w +1;
    p(ww) = c; % start of the object

    c = c + fprintf(fid,'%d 0 obj\r\n',ww);
    c = c + fprintf(fid,'[/PDF /Text]\r\n');
    c = c + fprintf(fid,'endobj\r\n\r\n');

    % We remember that this object was referenced by object 4 (the page node) in the resource dictionary under the ProcSet key.
    % The PDF operators used in content streams are grouped into categories of related operators called Procedure Sets.
    % This object holds an array (declared by the right and left brackets [ ]) of two procedure sets called PDF and Text.
    % It should be noted that as of PDF version 1.4 this information is not used by the reader, but is still generated so that older readers may work.

    % The final object is object (ww + 1), shown below.

    % Object (ww + 1) was also referenced by object 4 (the page node) in the resources dictionary as the value to the Font key.
    % The entries listed in this object are straightforward, and notice that the name /F1 is the same one referenced throughout the document.

    % This brings us to the cross-reference table.
    % The cross-reference table lists the information that permits access to indirect objects within the file.
    % Listing the file in this way allows a reader to read parts of the file before reading the entire thing (know as Random Access).
    % The cross-reference table is shown below.

    % compute the current object number
    ww = ww +1;
    p(ww) = c; % start of the object

    c = c + fprintf(fid,'%d 0 obj\r\n',ww);
    c = c + fprintf(fid,'<<\r\n');
    c = c + fprintf(fid,' /Type /Font\r\n');
    c = c + fprintf(fid,' /Subtype /Type1\r\n');
    c = c + fprintf(fid,' /Name /F1\r\n');
    c = c + fprintf(fid,' /BaseFont /Helvetica\r\n');
    c = c + fprintf(fid,' /Encoding /MacRomanEncoding\r\n');
    c = c + fprintf(fid,'>>\r\n');
    c = c + fprintf(fid,'endobj\r\n\r\n');

    % compute the current object
    ww = ww +1;

    c_xref = c; % start of xref

    c = c + fprintf(fid,'xref\r\n');
    c = c + fprintf(fid,'0 %d\r\n',ww);

    c = c + fprintf(fid,'0000000000 65535 f\r\n');
    c = c + fprintf(fid,'%010d 00000 n\r\n',p(1));
    c = c + fprintf(fid,'%010d 00000 n\r\n',p(2));
    c = c + fprintf(fid,'%010d 00000 n\r\n',p(3));
    c = c + fprintf(fid,'%010d 00000 n\r\n',p(4));
    c = c + fprintf(fid,'%010d 00000 n\r\n',p(5));
    for w=2:1:n_lines
        c = c + fprintf(fid,'%010d 00000 n\r\n',p(4+w));
    end
    c = c + fprintf(fid,'%010d 00000 n\r\n',p(4+w+1));
    c = c + fprintf(fid,'%010d 00000 n\r\n',p(4+w+2));

    % xref declares the start of the cross-reference table.
    % The next line introduces the cross-reference subsection.
    % For a file that has never been incrementally updated (such as this one), there will be only one cross-reference subsection.
    % Each cross-reference subsection contains entries for a contiguous range of object numbers.

    % The subsection begins with a line containing two numbers.
    % The first (0 in our case) is the object number of the first object and the second (8) contains the number of objects in that subsection.
    % Next lines contain the cross-reference entries themselves, one per line.
    % Lines are constructed as follows:
    %   If an entry is free 
    %       The entry should end with an f
    %       The first group of 10 numbers should be the (0 padded) object number of the next free object
    %       The group of 5 numbers should be the 5-digit generation number
    %   If an entry is in use 
    %       The entry should end with a u
    %       The first group of 10 numbers should be the (0 padded) byte offset in the stream
    %       The group of 5 numbers should be the 5-digit generation number

    % The first entry in the table will always be free and shall have a generation number of 65,535.
    % If it is the only free object (as in our case), it will have 0000000000 (itself) as the listing to the next free object.

    % Finally, the PDF file ends with the file trailer.
    % The file trailer links to the cross-reference table and other special objects.

    c = c + fprintf(fid,'trailer\r\n');
    c = c + fprintf(fid,'<<\r\n');
    c = c + fprintf(fid,' /Size %d\r\n',ww);
    c = c + fprintf(fid,' /Root 1 0 R\r\n');
    c = c + fprintf(fid,'>>\r\n');

    % The trailer is declared by the word trailer. Next we see the trailer dictionary:
    %   Size – Contains the total number of entries in the files cross-reference table
    %   Root – Contains the indirect reference to the root (catalog dictionary) of the document.

    % After the trailer dictionary is the startxref keyword, which gives the byte-offset to the xref keyword.

    c = c + fprintf(fid,'startxref\r\n');
    c = c + fprintf(fid,[num2str(c_xref) '\r\n']);

    % Finally, %%EOF declares the end of the PDF document.

    c = c + fprintf(fid,'%%%%EOF\r\n');

    % close the file
    fclose(fid);
    
    % all OK
    if (nargout == 1)
        ok = 1;
    end
    
catch
    % always try to close the file
    if exist('fid')
        fclose(fid);
    end
    
    % error
    if (nargout == 1)
        ok = 0;
    end
    return;
end

try
    if show_pdf
        % open the default pdf viewer
        % be careful, some pdf viewers do not update a modified file
        winopen(filename);
    end
catch
    disp(' ');
    disp(['Warning: an old version of ' filename ' is already open']);
    disp(' ');
    
    % error
    if (nargout == 1)
        ok = -2;
    end
end