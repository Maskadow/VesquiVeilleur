program veilleur;

uses crt , sysutils,proceduresJeuj;

Type endroit = record;
x,y,z : integer;
score : Integer;
expand : Boolean;
end;

procedure scoreCase (var place : endroit ; i:Integer);
begin
 if (place.expand = false) then
            for i := 0 to maxX*maxY
                if (caseArray[i].x == this.x+100 && caseArray[i].y == this.y ||
                    caseArray[i].x == this.x-100 && caseArray[i].y == this.y ||
                    caseArray[i].y == this.y+100 && caseArray[i].x == this.x ||
                    caseArray[i].y == this.y-100 && caseArray[i].x == this.x){
                    if (caseArray[i].score == "none" && caseArray[i].block == false){
                        caseArray[i].score = this.score + 1
                        this.hasExpand == true
                    }
end;

begin
endroit.score := 0;
end.
