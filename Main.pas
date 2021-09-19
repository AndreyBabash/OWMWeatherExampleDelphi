unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox, FMX.Layouts, FMX.Edit,
  FMX.ComboEdit, System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent, FMX.Memo, Json,
  FMX.ScrollBox;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    Label1: TLabel;
    labelCountry: TLabel;
    Label2: TLabel;
    humidityLabel: TLabel;
    pressureLabel: TLabel;
    cloudlabel: TLabel;
    lonLabel: TLabel;
    labelCity: TLabel;
    btnGetWeather: TButton;
    ScrollBox1: TScrollBox;
    CityBox: TComboEdit;
    tempLabel: TLabel;
    latlabel: TLabel;
    ResponseField: TMemo;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnGetWeatherClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    responsejson:string;
    owmadress:string;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

// ������� ��� ��������� ������ �� ������� (����� � ������� Json)
function idHttpGet(const aURL: string): string;
// uses  System.Net.HttpClient, System.Net.HttpClientComponent, System.Net.URLClient;
var
  Resp: TStringStream;
  Return: IHTTPResponse;
begin
  Result := '';
  with TNetHTTPClient.Create(nil) do
  begin
    Resp := TStringStream.Create('', TEncoding.ANSI);
    Return := Get( { TURI.URLEncode } (aURL), Resp);
    Result := Resp.DataString;
    Resp.Free;
    Free;
  end;
end;

procedure TForm1.btnGetWeatherClick(Sender: TObject);
var JSON,JSONMain,JSONCountry,
    JSONCoords: TJSONObject;
    JSONDetail: TJSONArray;
    city:string;
    degrees,kelvins:double;
begin
    // �������� �����
    city:=CityBox.Text;
    owmadress:='http://api.openweathermap.org/data/2.5/weather?q='+city+'&appid='+'ffe6d300f48841172ae985a4d1f3c576';

    // ������ ������ � ������� OWM � �������� ������ � ������ � JSON
    responsejson:=idHttpGet(owmadress);

    // �������� ����� �� ������� � ���� memo
    ResponseField.Lines.Clear;
    ResponseField.Text:=responsejson;

    // ������ ���������� ����� � ������� �� ���� ����������
    JSON := TJSONObject.ParseJSONValue(responsejson) as TJSONObject;

    JSONMain:=TJSONObject(JSON.Get('main').JsonValue);
    JSONDetail:=TJSONArray(JSON.Get('weather').JsonValue);
    JSONCountry:=TJSONObject(JSON.Get('sys').JsonValue);
    JSONCoords:=TJSONObject(JSON.Get('coord').JsonValue);

    // ��������� ����������� �� ��������� � �������
    kelvins:=Double.Parse(JSONMain.GetValue('temp').Value);
    degrees:=kelvins-273.15;

    // ������� ������������
    tempLabel.Text:='����������� �������: '+FloatToStrF(degrees,ffGeneral,3,3)+' ��';
    labelCountry.Text:='������: '+JSONCountry.GetValue('country').Value;
    labelCity.Text:='�����: '+JSON.GetValue('name').Value;
    cloudlabel.Text:='����������: '+(TJSONPair(TJSONObject(JSONDetail.Get(0)).Get('description')).JsonValue.Value);
    humidityLabel.Text:='���������: '+JSONMain.GetValue('humidity').Value+' %';
    pressureLabel.Text:='����������� ��������: '+JSONMain.GetValue('pressure').Value+' hPa';
    lonLabel.Text:='�������: '+JSONCoords.GetValue('lon').Value;
    latlabel.Text:='������: '+JSONCoords.GetValue('lat').Value;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Toolbar1.TintColor:=TAlphaColors.Green;
  owmadress:='http://api.openweathermap.org/data/2.5/weather?q='+'����������'+'&appid='+'ffe6d300f48841172ae985a4d1f3c576';
end;

end.
