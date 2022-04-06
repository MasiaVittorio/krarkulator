import 'package:flutter/material.dart';
import 'package:krarkulator/data/all.dart';

enum MtgColor {
  w,
  u,
  b,
  r,
  g,
}



extension MtgColorData on MtgColor? {

  String get label {
    switch (this) {
      case MtgColor.w:
        return "White";
      case MtgColor.u:
        return "Blue";
      case MtgColor.b:
        return "Black";
      case MtgColor.r:
        return "Red";
      case MtgColor.g:
        return "Green";
      case null:
        return "Colorless";
    }
  }

  Color get color {
    switch (this) {
      case MtgColor.w:
        return const Color(0xFFFFFED8);
      case MtgColor.u:
        return const Color(0xFFA9DCEF);
      case MtgColor.b:
        return const Color(0xFFB3ADAF);
      case MtgColor.r:
        return const Color(0xFFEEA489);
      case MtgColor.g:
        return const Color(0xFF93CBA4);
      case null:
        return const Color(0xFFCAC3C0);
    }
  }

  IconData get icon {
    switch (this) {
      case MtgColor.w:
        return ManaIcons.w;
      case MtgColor.u:
        return ManaIcons.u;
      case MtgColor.b:
        return ManaIcons.b;
      case MtgColor.r:
        return ManaIcons.r;
      case MtgColor.g:
        return ManaIcons.g;
      case null:
        return ManaIcons.c;
    }
  }

  Widget widget({double size = 28}) => Container(
    margin: EdgeInsets.all(size * 0.055),
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(size),
    ),
    child: Icon(icon, color: Colors.black, size: size * 0.70,),
  );
}

extension ManaOrder on Map<MtgColor?, int>{

  List<MtgColor?> get orderedColors {
  const w = MtgColor.w;
  const u = MtgColor.u;
  const b = MtgColor.b;
  const r = MtgColor.r;
  const g = MtgColor.g;
  const c = null;

    List<MtgColor?> id = [
      for(final color in const [w, u, b, r, g, c])
        if((this[color] ?? 0) > 0)
          color,
    ];

    const map2 = <MtgColor?,Map<MtgColor?,List<MtgColor?>>>{
      w: {
        u: [w, u],
        b: [w, b],
        r: [r, w],
        g: [g,w],
        c: [c, w],
      },
      MtgColor.u: { 
        b: [u, b],
        r: [u, r],
        g: [g, u],
        c: [c, u],
      },
      MtgColor.b: {
        r: [b, r],
        g: [b, g],
        c: [c, b],
      },
      MtgColor.r: {
        g: [r, g],
        c: [c, r],
      },
      MtgColor.g: {
        c: [c, g],
      },
    };

    const map3 = <MtgColor?, Map<MtgColor?,Map<MtgColor?,List<MtgColor?>>>>{
      w: { // w??
        u: { //wu?
          b: [w, u, b], //wub -> esper
          r: [u, r, w], //wur -> jeskai -> u r w
          g: [g, w, u], //wug -> bant -> gwu
          c: [c, w, u], //wuc -> c + azorius -> cwu
        },
        b: { //wb?
          r: [r, w, b], //wbr -> mardu -> r w b
          g: [w, b, g], //wbg -> azban -> w b g
          c: [c, g, w], //wbc -> c + orzhov -> cgw
        },
        r: { //wr?
          g: [r,g,w], //wrg -> naya -> rgw
          c: [c,r,w], //wrc -> c + boros -> crw
        },
        g: { //wg? -> wgc for sure
          c: [c,g,w], /// wgc -> c + selesnya -> cgw
        },
      },
      u: { // u??
        b: { //ub?
          r: [u,b,r], //ubr -> grixis -> ubr
          g: [b,g,u], //ubg -> sultai -> b g u
          c: [c,u,b], //ubc -> c + dimir -> cub
        },
        r: {//ur?
          g: [g,u,r], //urg -> temur -> g u r
          c: [c,u,r], //urc -> c + izzet -> cur
        },
        g: { //ug? -> ugc for sure
          c: [c,g,u], // ugc -> c+simic -> cgu
        },
      },
      b: { //b??
        r: { //br?
          g: [b,r,g], //brg -> jund -> brg
          c: [c,b,r], //brc -> c + rakdos -> cbr
        },
        g: {//bg? surely bgc
          c: [c,b,g], //bgc -> c+golgari -> cbg
        },
      },
      r: {// r?? surely rgc
        g: { // rg? surely rgc
          c: [c,r,g], //rgc -> c+gruul -> crg
        },
      },
    };

    const map4 = <MtgColor?,Map<MtgColor?, Map<MtgColor?,Map<MtgColor?,List<MtgColor?>>>>>{
      w: { //wXXX
        u: { //wuXX
          b: { //wubX
            r: [w,u,b,r], //wubr
            g: [g,w,u,b], //wubg -> gwub
            c: [c,w,u,b], //wubc -> c+esper
          },
          r: { //wurX
            g: [r,g,w,u], //wurg -> rgwu
            c: [c,u,r,w], //wurc -> c + jeskai
          },
          g: { //wugX surely wugc
            c: [c,g,w,u], //wugc -> c + bant
          },
        },
        b: { //wbXX
          r: { //wbrX
            g: [b,r,g,w], //wbrg -> brgw
            c: [c,r,w,b], ////wbrc -> c + mardu
          },
          g: { //wbgX surely wbgc
            c: [c,w,b,c], //wbgc -> c + abzan
          },
        },
        r: { //wrXX surely wrgc
          g: { //wrgX surely wrgc
            c: [c,r,g,w], //wrgc -> c + naya
          },
        },
      },
      u: { //uXXX
        b: { //ubXX
          r: { //ubrX
            g: [u,b,r,g], //ubrg -> ubrg
            c: [c,u,b,r], ////ubrc -> c + grixis
          },
          g: { //ubgX surely ubgc
            c: [c,b,g,u], //ubgc -> c + sultai
          },
        },
        r: { //urXX surely urgc
          g: { //urgX surely urgc
            c: [c,g,u,r], //urgc -> c + temur
          },
        },
      },
      b: { //bXXX surely brgc
        r: { //brXX surely brgc
          g: { //brgX surely brgc
            c: [c,b,r,g], //brgc -> c + jund
          },
        },
      },
    };

    switch (id.length) {
      case 0:
      case 1:
        return [...id];
      case 2:
        return map2[id[0]]![id[1]]!;
      case 3:
        return map3[id[0]]![id[1]]![id[2]]!;
      case 4: 
        return map4[id[0]]![id[1]]![id[2]]![id[3]]!;
      case 5:
        if(!id.contains(null)) return const [w,u,b,r,g];
        // surely id == [4 colors + c]
        return [
          null,
          ...(map4[id[0]]![id[1]]![id[2]]![id[3]]!),
        ];
      default: 
        return const [c,w,u,b,r,g];
    }
  }

  bool get hasSomething {
    for(final k in keys)
      if((this[k] ?? 0) > 0)
        return true;
    return false;
  }

  Widget costWidget({double? size, void Function(MtgColor?)? onTap}) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for(final color in orderedColors)
        for(int i=0; i<this[color]!; ++i)
          onTap == null 
            ? color.widget(size: size ?? 28)
            : GestureDetector(
            onTap: () => onTap(color),
            child: color.widget(size: size ?? 28),
          ),
    ],
  );
}

class ManaPool {

  late Map<MtgColor?, int> pool;

  ManaPool([Map<MtgColor?, int>? _pool]){
    pool = _pool ?? <MtgColor?,int>{
      MtgColor.w: 0,
      MtgColor.u: 0,
      MtgColor.b: 0,
      MtgColor.r: 0,
      MtgColor.g: 0,
      null: 0,
    };
  }

  void empty() {
    for (final c in MtgColor.values) pool[c] = 0;
    pool[null] = 0;
  }

  int debtIfWouldTryToPay(Map<MtgColor?, int> cost){
    int debt = 0;
    for (final c in cost.keys) {
      if ((pool[c] ?? 0) >= (cost[c] ?? 0)) {
        // could pay this color
      } else {
        debt += ((cost[c] ?? 0) - (pool[c] ?? 0));
      }
    }
    return debt;

  }

  int pay(Map<MtgColor?, int> cost) {
    int debt = 0;
    for (final c in cost.keys) {
      if ((pool[c] ?? 0) >= (cost[c] ?? 0)) {
        pool[c] = (pool[c] ?? 0) - (cost[c] ?? 0);
      } else {
        debt += ((cost[c] ?? 0) - (pool[c] ?? 0));
        pool[c] = 0;
      }
    }
    return debt;
  }

  void add(Map<MtgColor?, int> product) {
    for (final c in product.keys) {
      if ((product[c] ?? 0) > 0) {
        pool[c] = (pool[c] ?? 0) + (product[c] ?? 0);
      } 
    }
  }

  static const _clrless = "colorless";
  Map<String, int> get toJson => <String,int>{
    for (final c in MtgColor.values)
      c.name: pool[c] ?? 0,
    _clrless: pool[null] ?? 0,
  };

  static ManaPool fromJson(Map<String, dynamic> json) => ManaPool(
    <MtgColor?,int>{
      for (final c in MtgColor.values) 
        c: json[c.name] ?? 0, 
      null: json[_clrless] ?? 0,
    },
  );
}
