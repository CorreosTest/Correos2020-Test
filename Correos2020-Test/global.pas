unit Global;

{$mode objfpc}{$H+}

interface
  procedure Traducir;

uses
  Classes, SysUtils, Translations;

implementation
   uses
      Unit1, Unit2;
end.

procedure Traducir;
var
  Lang, FallbackLang: string;
begin
  Lang := 'es';
  FallBackLang := '';
  //TranslateUnitResourceStrings('LclStrConsts','lclstrconsts.es.po', Lang, FallbackLang);
  TranslateUnitResourceStrings('lr_const','lr_const.es.po', Lang, FallbackLang);
  //TranslateUnitResourceStrings('printer4lazstrconst','printer4lazstrconst.es.po', Lang, FallbackLang);
end;

