class PainterRating{
  double payment,rating,vwe;
  int we,vpayment;
 PainterRating({this.payment,this.we});
  int marketPricePlumber = 3200;
  double calculateRating(){
    if(payment<marketPricePlumber){
      vpayment=2;
    }else{
      vpayment =1;
    }
    if(we<1){
      vwe=0;
    }
    else if(we == 1){
      vwe= 1;
    }
    else if(we <= 4){
      vwe= 2;
    }
    else if(we > 4){
      vwe= 3;
    }
    rating =vwe + vpayment;
    return rating;
  }

}