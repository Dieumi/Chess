package agent;

import Chess.Spot;
import agent.Move;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.DeclareMixin;
import piece.*;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

/**
 * Created by oxeyo on 15/11/2017.
 */
@Aspect
public aspect ismovelegal {
    pointcut  checkMove(Move mv,Player p ) :  execution (public boolean agent.Player.move(..)) && target(p) && args(mv);

    boolean around  (Move mv,Player p) : checkMove(mv,  p ){

        try{
            if (mv.yI == mv.yF && mv.xI == mv.xF)
                return false;
            Spot[][] g=p.getPlayGround().getGrid();

            Piece piece=g[mv.xI][mv.yI].getPiece();
            if(p.getClass()==HumanPlayer.class){

                if(piece==null || !Character.isUpperCase(piece.toString().charAt(0))){
                    return false;
                }else{
                    Class c =piece.getClass();
                    if(c== Pawn.class){

                        if(mv.xF==mv.xI && mv.yF==mv.yI+1 && g[mv.xF][mv.yF].getPiece()==null || ((mv.xF==mv.xI+1 ||mv.xF==mv.xI-1) &&  mv.yF==mv.yI+1  && g[mv.xF][mv.yF].getPiece()!=null)){
                            System.out.println("correct");
                            
                        }else{
                            return false;

                        }
                    }else if(c== Bishop.class){
                        Bishop pawn=new Bishop(0);
                        if(Math.abs(mv.xF- mv.xI) == Math.abs(mv.yF - mv.yI)){
                           /* for(int i=mv.yI;i<=mv.yF;i++){
                                System.out.println(i);
                                for(int y=mv.xI+i;y<=mv.xF+i;y++){
                                    System.out.println(String.valueOf(y));
                                    if(g[y][i].getPiece()!=null && g[y][i].getPiece().getClass()!=Bishop.class && Character.isUpperCase(String.valueOf(g[y][i].getPiece().toString()).charAt(0))){

                                        return false;
                                    }
                                }
                            }
                            for(int i=mv.yF;i<=mv.yI;i++){
                                System.out.println(i);
                                for(int y=mv.xF+i;y<=mv.xI+i;y++){
                                    System.out.println(String.valueOf(y));
                                    if(g[y][i].getPiece()!=null && g[y][i].getPiece().getClass()!=Bishop.class && Character.isUpperCase(String.valueOf(g[y][i].getPiece().toString()).charAt(0))){

                                        return false;
                                    }
                                }
                            }
                            System.out.println("correct");
                            */
                            int differenceInRows = Math.abs(mv.yI - mv.yF);
                            if(differenceInRows>1){
                                for (int j = 1; j <differenceInRows; j++) {
                                    if ((mv.yF < mv.yI) && (mv.xF > mv.xI)
                                            && g[mv.xI + j][mv.yI - j].getPiece() != null) {
                                        return false;
                                    } else if ((mv.yF > mv.yI) && (mv.xF > mv.xI)
                                            && g[mv.xI + j][mv.yI + j].getPiece() != null) {
                                        return false;
                                    } else if ((mv.yF > mv.yI) && (mv.xF < mv.xI)
                                            && g[mv.xI - j][mv.yI + j].getPiece() != null) {
                                        return false;
                                    } else if ((mv.yF < mv.yI) && (mv.xF < mv.xI)
                                            && g[mv.xI - j][mv.yI - j].getPiece() != null) {
                                        return false;
                                    }

                                }
                            }else{
                                if ((mv.yF < mv.yI) && (mv.xF > mv.xI)
                                        && g[mv.xI ][mv.yI ].getPiece() != null) {
                                    return false;
                                } else if ((mv.yF > mv.yI) && (mv.xF > mv.xI)
                                        && g[mv.xI][mv.yI ].getPiece() != null) {
                                    return false;
                                } else if ((mv.yF > mv.yI) && (mv.xF < mv.xI)
                                        && g[mv.xI ][mv.yI ].getPiece() != null) {
                                    return false;
                                } else if ((mv.yF < mv.yI) && (mv.xF < mv.xI)
                                        && g[mv.xI ][mv.yI ].getPiece() != null) {
                                    return false;
                                }
                            }


                            
                        }else{
                            return false;
                        }
                    }else if(c== King.class){
                        King pawn=new King(0);
                        if(mv.xI!=mv.xF && mv.yI!=mv.yF && ((mv.xF==mv.xI+1 || mv.xF==mv.xI-1) && (mv.yF==mv.yI+1||mv.yF==mv.yI-1) )){
                            if ((mv.yF < mv.yI) && (mv.xF > mv.xI)
                                    && g[mv.xI ][mv.yI ].getPiece() != null) {
                                return false;
                            } else if ((mv.yF > mv.yI) && (mv.xF > mv.xI)
                                    && g[mv.xI][mv.yI ].getPiece() != null) {
                                return false;
                            } else if ((mv.yF > mv.yI) && (mv.xF < mv.xI)
                                    && g[mv.xI ][mv.yI ].getPiece() != null) {
                                return false;
                            } else if ((mv.yF < mv.yI) && (mv.xF < mv.xI)
                                    && g[mv.xI ][mv.yI ].getPiece() != null) {
                                return false;
                            }

                        }else if(mv.xI==mv.xF && ((mv.yF==mv.yI+1||mv.yF==mv.yI-1) )){
                            for(int y=mv.yI;y<=mv.yF;y++){
                                System.out.println(String.valueOf(y));
                                if(g[mv.xI][y].getPiece()!=null && g[mv.xI][y].getPiece().getClass()!=King.class && Character.isUpperCase(String.valueOf(g[mv.xI][y].getPiece().toString()).charAt(0))){
                                    return false;
                                }
                            }

                        }else if( mv.yI==mv.yF && (mv.xF==mv.xI+1 || mv.xF==mv.xI-1 )){
                            for(int y=mv.xI;y<=mv.xF;y++){
                                System.out.println(String.valueOf(y));
                                if(g[y][mv.yF].getPiece()!=null && g[mv.xI][y].getPiece().getClass()!=King.class && Character.isUpperCase(String.valueOf(g[mv.xI][y].getPiece().toString()).charAt(0)) ){
                                    return false;
                                }
                            }

                        }else{
                            return false;
                        }
                        
                    }else if(c== Knight.class){
                        Knight pawn=new Knight(0);
                        int row = Math.abs(mv.yF - mv.yI);
                        int col = Math.abs(mv.xF - mv.xI);

                        if(((row == 2 && col == 1) || (row == 1 && col == 2)) ){
                            Piece target=g[mv.xF][mv.yF].getPiece();
                            if(target==null){
                                
                            }else if(Character.isUpperCase(target.toString().charAt(0))){
                                return false;
                            }else{
                                
                            }

                        }else{
                            return false;
                        }
                    }else if(c== Queen.class){
                        Queen pawn=new Queen(0);
                        if(Math.abs(mv.xF- mv.xI) == Math.abs(mv.yF - mv.yI)){
                            //Deplacement Diagonnal
                           /* for(int i=mv.yI;i<mv.yF;i++){
                                System.out.println(i);
                                for(int y=mv.xI+i;y<=mv.xF+i;y++){
                                    System.out.println(String.valueOf(y));
                                    if(g[y][i].getPiece()!=null && g[y][i].getPiece().getClass()!=Queen.class && Character.isUpperCase(String.valueOf(g[y][i].getPiece().toString()).charAt(0))){
                                        return false;
                                    }
                                }
                            }
                            for(int i=mv.yF+1;i<mv.yI;i++){
                                System.out.println(i);
                                for(int y=mv.xF+i;y<=mv.xI+i;y++){
                                    System.out.println(String.valueOf(y));
                                    if(g[y][i].getPiece()!=null && g[y][i].getPiece().getClass()!=Queen.class && Character.isUpperCase(String.valueOf(g[y][i].getPiece().toString()).charAt(0))){

                                        return false;
                                    }
                                }
                            }*/
                            int differenceInRows = Math.abs(mv.yI - mv.yF);
                            if(differenceInRows>1){
                                for (int j = 1; j <differenceInRows; j++) {
                                    if ((mv.yF < mv.yI) && (mv.xF > mv.xI)
                                            && g[mv.xI + j][mv.yI - j].getPiece() != null) {
                                        return false;
                                    } else if ((mv.yF > mv.yI) && (mv.xF > mv.xI)
                                            && g[mv.xI + j][mv.yI + j].getPiece() != null) {
                                        return false;
                                    } else if ((mv.yF > mv.yI) && (mv.xF < mv.xI)
                                            && g[mv.xI - j][mv.yI + j].getPiece() != null) {
                                        return false;
                                    } else if ((mv.yF < mv.yI) && (mv.xF < mv.xI)
                                            && g[mv.xI - j][mv.yI - j].getPiece() != null) {
                                        return false;
                                    }

                                }
                            }else{
                                if ((mv.yF < mv.yI) && (mv.xF > mv.xI)
                                        && g[mv.xI ][mv.yI ].getPiece() != null) {
                                    return false;
                                } else if ((mv.yF > mv.yI) && (mv.xF > mv.xI)
                                        && g[mv.xI][mv.yI ].getPiece() != null) {
                                    return false;
                                } else if ((mv.yF > mv.yI) && (mv.xF < mv.xI)
                                        && g[mv.xI ][mv.yI ].getPiece() != null) {
                                    return false;
                                } else if ((mv.yF < mv.yI) && (mv.xF < mv.xI)
                                        && g[mv.xI ][mv.yI ].getPiece() != null) {
                                    return false;
                                }
                            }



                        }else if (mv.yI == mv.yF && mv.xI == mv.xF)
                            return false;


                        // Check if destination cell is free
                        if (g[mv.xF][mv.yF].getPiece()!= null && Character.isUpperCase(String.valueOf(g[mv.xF][mv.yF].getPiece()).charAt(0)) )
                            return false;

                        if (mv.yI == mv.yF) { // Horizontal move
                            int dx = (mv.xI < mv.xF) ? 1 : -1;

                            for (int i = mv.xI + dx; i != mv.xF; i += dx)
                                if (g[i][mv.yI].getPiece() != null)
                                    return false;

                        } else if (mv.xI == mv.xF) { // Vertical move
                            int dy = (mv.yI < mv.yF) ? 1 : -1;

                            for (int i = mv.yI + dy; i != mv.yF; i += dy){
                                if (g[mv.xI][i].getPiece() != null){
                                    return false;
                                }

                            }

                            
                        }

                    }else if(c== Rook.class){
                        Rook pawn=new Rook(0);
                       /* if(mv.xI==mv.xF ){
                            for(int y=mv.yI+1;y<=mv.yF;y++){
                                System.out.println(String.valueOf(y));
                                if(g[mv.xI][y].getPiece()!=null){
                                    return false;
                                }
                            }
                            for(int y=mv.yF+1;y<=mv.yI;y++){
                                System.out.println(String.valueOf(y));
                                if(g[mv.xF][y].getPiece()!=null){
                                    return false;
                                }
                            }
                            
                        }else if( mv.yI==mv.yF){
                            for(int y=mv.xI+1;y<=mv.xF;y++){
                                System.out.println(String.valueOf(y));
                                if(g[y][mv.yF].getPiece()!=null){
                                    return false;
                                }
                            }
                            for(int y=mv.xF+1;y<=mv.xI;y++){
                                System.out.println(String.valueOf(y));
                                if(g[y][mv.yI].getPiece()!=null){
                                    return false;
                                }
                            }*/


                        // Check if destination cell is free
                        if (g[mv.xF][mv.yF].getPiece()!= null && Character.isUpperCase(String.valueOf(g[mv.xF][mv.yF].getPiece()).charAt(0)) )
                            return false;

                        if (mv.yI == mv.yF) { // Horizontal move
                            int dx = (mv.xI < mv.xF) ? 1 : -1;

                            for (int i = mv.xI + dx; i != mv.xF; i += dx)
                                if (g[i][mv.yI].getPiece() != null)
                                    return false;

                        } else if (mv.xI == mv.xF) { // Vertical move
                            int dy = (mv.yI < mv.yF) ? 1 : -1;

                            for (int i = mv.yI + dy; i != mv.yF; i += dy){
                                if (g[mv.xI][i].getPiece() != null){
                                    return false;
                                }

                            }


                        }else{
                            return false;
                        }
                        
                    }
                }
            }else{
                if(piece==null || Character.isUpperCase(piece.toString().charAt(0))){
                    return false;
                }else{
                    Class c =piece.getClass();
                    if(c== Pawn.class){
                        Pawn pawn=new Pawn(0);
                        if(mv.xF==mv.xI && mv.yF==mv.yI-1 || ((mv.xF==mv.xI+1 ||mv.xF==mv.xI-1) &&  mv.yF==mv.yI-1 && g[mv.xF][mv.yF].getPiece()!=null)){
                            System.out.println("correct");
                            
                        }else{
                            return false;
                        }
                    }else if(c== Bishop.class){
                        Bishop pawn=new Bishop(0);
                        if(Math.abs(mv.xF- mv.xI) == Math.abs(mv.yF - mv.yI)){
                            int differenceInRows = Math.abs(mv.yI - mv.yF);

                            if(differenceInRows>1){
                                for (int j = 1; j <differenceInRows; j++) {
                                    if ((mv.yF < mv.yI) && (mv.xF > mv.xI)
                                            && g[mv.xI + j][mv.yI - j].getPiece() != null) {
                                        return false;
                                    } else if ((mv.yF > mv.yI) && (mv.xF > mv.xI)
                                            && g[mv.xI + j][mv.yI + j].getPiece() != null) {
                                        return false;
                                    } else if ((mv.yF > mv.yI) && (mv.xF < mv.xI)
                                            && g[mv.xI - j][mv.yI + j].getPiece() != null) {
                                        return false;
                                    } else if ((mv.yF < mv.yI) && (mv.xF < mv.xI)
                                            && g[mv.xI - j][mv.yI - j].getPiece() != null) {
                                        return false;
                                    }

                                }
                            }else{
                                if ((mv.yF < mv.yI) && (mv.xF > mv.xI)
                                        && g[mv.xI ][mv.yI ].getPiece() != null) {
                                    return false;
                                } else if ((mv.yF > mv.yI) && (mv.xF > mv.xI)
                                        && g[mv.xI][mv.yI ].getPiece() != null) {
                                    return false;
                                } else if ((mv.yF > mv.yI) && (mv.xF < mv.xI)
                                        && g[mv.xI ][mv.yI ].getPiece() != null) {
                                    return false;
                                } else if ((mv.yF < mv.yI) && (mv.xF < mv.xI)
                                        && g[mv.xI ][mv.yI ].getPiece() != null) {
                                    return false;
                                }
                            }
                            

                        }else{
                            return false;
                        }
                    }else if(c== King.class){
                        King pawn=new King(0);
                        if (g[mv.xF][mv.yF].getPiece()!= null && !Character.isUpperCase(String.valueOf(g[mv.xF][mv.yF].getPiece()).charAt(0)) )
                            return false;
                        if(mv.xI!=mv.xF && mv.yI!=mv.yF && ((mv.xF==mv.xI+1 || mv.xF==mv.xI-1) && (mv.yF==mv.yI+1||mv.yF==mv.yI-1) )){
                            if ((mv.yF < mv.yI) && (mv.xF > mv.xI)
                                    && g[mv.xI ][mv.yI ].getPiece() != null) {
                                return false;
                            } else if ((mv.yF > mv.yI) && (mv.xF > mv.xI)
                                    && g[mv.xI][mv.yI ].getPiece() != null) {
                                return false;
                            } else if ((mv.yF > mv.yI) && (mv.xF < mv.xI)
                                    && g[mv.xI ][mv.yI ].getPiece() != null) {
                                return false;
                            } else if ((mv.yF < mv.yI) && (mv.xF < mv.xI)
                                    && g[mv.xI ][mv.yI ].getPiece() != null) {
                                return false;
                            }

                        }else if(mv.xI==mv.xF && ((mv.yF==mv.yI+1||mv.yF==mv.yI-1) )){
                            for(int y=mv.yI+1;y<=mv.yF;y++){
                                System.out.println(String.valueOf(y));
                                if(g[mv.xI][y].getPiece()!=null){
                                    return false;
                                }
                            }
                            
                        }else if( mv.yI==mv.yF && (mv.xF==mv.xI+1 || mv.xF==mv.xI-1 )) {
                            for (int y = mv.xI + 1; y <= mv.xF; y++) {
                                System.out.println(String.valueOf(y));
                                if (g[y][mv.yF].getPiece() != null) {
                                    return false;
                                }
                            }
                            
                        }else{
                            return false;
                        }

                    }else if(c== Knight.class){
                        Knight pawn=new Knight(0);

                        int row = Math.abs(mv.yF - mv.yI);
                        int col = Math.abs(mv.xF - mv.xI);

                        if(((row == 2 && col == 1) || (row == 1 && col == 2)) ){
                            Piece target=g[mv.yF][mv.xF].getPiece();
                            if(target==null){
                                
                            }else if(Character.isUpperCase(target.toString().charAt(0))){
                                return false;
                            }else{
                                
                            }

                        }else{
                            return false;
                        }
                    }else if(c== Queen.class){
                        if(Math.abs(mv.xF- mv.xI) == Math.abs(mv.yF - mv.yI)){
                            int differenceInRows = Math.abs(mv.yI - mv.yF);

                            if(differenceInRows>1){
                                for (int j = 1; j <differenceInRows; j++) {
                                    if ((mv.yF < mv.yI) && (mv.xF > mv.xI)
                                            && g[mv.xI + j][mv.yI - j].getPiece() != null) {
                                        return false;
                                    } else if ((mv.yF > mv.yI) && (mv.xF > mv.xI)
                                            && g[mv.xI + j][mv.yI + j].getPiece() != null) {
                                        return false;
                                    } else if ((mv.yF > mv.yI) && (mv.xF < mv.xI)
                                            && g[mv.xI - j][mv.yI + j].getPiece() != null) {
                                        return false;
                                    } else if ((mv.yF < mv.yI) && (mv.xF < mv.xI)
                                            && g[mv.xI - j][mv.yI - j].getPiece() != null) {
                                        return false;
                                    }

                                }
                            }else{
                                if ((mv.yF < mv.yI) && (mv.xF > mv.xI)
                                        && g[mv.xI ][mv.yI ].getPiece() != null) {
                                    return false;
                                } else if ((mv.yF > mv.yI) && (mv.xF > mv.xI)
                                        && g[mv.xI][mv.yI ].getPiece() != null) {
                                    return false;
                                } else if ((mv.yF > mv.yI) && (mv.xF < mv.xI)
                                        && g[mv.xI ][mv.yI ].getPiece() != null) {
                                    return false;
                                } else if ((mv.yF < mv.yI) && (mv.xF < mv.xI)
                                        && g[mv.xI ][mv.yI ].getPiece() != null) {
                                    return false;
                                }
                            }
                            
                        }else if (mv.yI == mv.yF && mv.xI == mv.xF)
                            return false;

                        // Check if destination cell is free
                        if (g[mv.xF][mv.yF].getPiece()!= null && !Character.isUpperCase(String.valueOf(g[mv.xF][mv.yF].getPiece()).charAt(0)) )
                            return false;

                        if (mv.yI == mv.yF) { // Horizontal move
                            int dx = (mv.xI < mv.xF) ? 1 : -1;

                            for (int i = mv.xI + dx; i != mv.xF; i += dx)
                                if (g[i][mv.yI].getPiece() != null)
                                    return false;

                        } else if (mv.xI == mv.xF) { // Vertical move
                            int dy = (mv.yI < mv.yF) ? 1 : -1;

                            for (int i = mv.yI + dy; i != mv.yF; i += dy){
                                if (g[mv.xI][i].getPiece() != null){
                                    return false;
                                }

                            }


                        }else{
                            return false;
                        }
                        
                    }else if(c== Rook.class){
                        Rook pawn=new Rook(0);
                        if (mv.yI == mv.yF && mv.xI == mv.xF)
                            return false;

                        // Check if destination cell is free
                        if (g[mv.xF][mv.yF].getPiece()!= null && Character.isUpperCase(String.valueOf(g[mv.xF][mv.yF].getPiece()).charAt(0)) )
                            return false;

                        if (mv.yI == mv.yF) { // Horizontal move
                            int dx = (mv.xI < mv.xF) ? 1 : -1;

                            for (int i = mv.xI + dx; i != mv.xF; i += dx)
                                if (g[i][mv.yI].getPiece() != null)
                                    return false;

                        } else if (mv.xI == mv.xF) { // Vertical move
                            int dy = (mv.yI < mv.yF) ? 1 : -1;

                            for (int i = mv.yI + dy; i != mv.yF; i += dy){
                                if (g[mv.xI][i].getPiece() != null){
                                    return false;
                                }

                            }


                        }else{
                            return false;
                        }
                        
                    }
                }
            }


        }catch (Exception e){
            System.out.println(e);
        }
        try {
            File file=new File("result.txt");
            System.out.println(file.getAbsolutePath());
            String s =mv.toString()+"\r\n";
            Files.write(Paths.get(file.getAbsolutePath()), s.getBytes() , StandardOpenOption.APPEND);
        } catch (Exception e) {
            e.printStackTrace();
        }
        p.getPlayGround().movePiece(mv);
        return true;
    }

    pointcut  jourNalisation() :  execution (public static void Chess.Game.main(..)) ;
    before() : jourNalisation()  {
      //System.out.println("test");
        File file=new File("result.txt");
        PrintWriter writer = null;
        try {
            writer = new PrintWriter(file);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        writer.print("");
        writer.close();

       /* String line = "" + thisJoinPointStaticPart.getSourceLocation().getLine();

        String src = thisJoinPointStaticPart.getSourceLocation().getWithinType().getCanonicalName();
        System.out.println("Appel  DE:" + src + " ligne: " + line + " \n\tA:" + sig.getDeclaringTypeName() + "."
                + sig.getName());*/
    }

}
