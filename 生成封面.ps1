$drawingDir = Split-Path ([System.Drawing.Bitmap].Assembly.Location)
Add-Type -ReferencedAssemblies @(
    [System.Drawing.Bitmap].Assembly.Location,
    [System.Drawing.Color].Assembly.Location,
    (Join-Path $drawingDir 'System.Private.Windows.GdiPlus.dll'),
    (Join-Path $drawingDir 'System.Private.Windows.Core.dll')
) -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;

public static class TingXiArt {
    static readonly Color Ink = Color.FromArgb(11, 23, 36);

    static GraphicsPath RoundRect(float x, float y, float w, float h, float r) {
        var path = new GraphicsPath();
        path.AddArc(x, y, 2*r, 2*r, 180, 90);
        path.AddArc(x+w-2*r, y, 2*r, 2*r, 270, 90);
        path.AddArc(x+w-2*r, y+h-2*r, 2*r, 2*r, 0, 90);
        path.AddArc(x, y+h-2*r, 2*r, 2*r, 90, 90);
        path.CloseFigure();
        return path;
    }

    static void Logo(Graphics g, float x, float y, float size) {
        var state = g.Save();
        g.TranslateTransform(x, y);
        g.ScaleTransform(size / 256f, size / 256f);
        using (var shape = RoundRect(0, 0, 256, 256, 54))
        using (var gradient = new LinearGradientBrush(new Point(0, 0), new Point(256, 256),
            Color.FromArgb(101, 216, 191), Color.FromArgb(98, 157, 237)))
            g.FillPath(gradient, shape);
        using (var ink = new SolidBrush(Ink)) {
            g.FillPie(ink, 36, 70, 84, 116, 90, 180);
            g.FillPie(ink, 136, 70, 84, 116, 270, 180);
        }
        using (var pen = new Pen(Ink, 12)) {
            pen.StartCap = LineCap.Round;
            pen.EndCap = LineCap.Round;
            pen.LineJoin = LineJoin.Round;
            g.DrawLines(pen, new[] { new Point(91,128), new Point(101,128), new Point(111,100),
                new Point(123,154), new Point(135,88), new Point(147,168),
                new Point(157,128), new Point(167,128) });
        }
        g.Restore(state);
    }

    public static void Generate(string directory) {
        byte[] iconPng;
        using (var bitmap = new Bitmap(256, 256))
        using (var g = Graphics.FromImage(bitmap)) {
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.Clear(Color.Transparent);
            Logo(g, 0, 0, 256);
            using (var stream = new MemoryStream()) {
                bitmap.Save(stream, ImageFormat.Png);
                iconPng = stream.ToArray();
            }
        }
        using (var stream = new FileStream(Path.Combine(directory, "TingXi.ico"), FileMode.Create))
        using (var writer = new BinaryWriter(stream)) {
            writer.Write((ushort)0); writer.Write((ushort)1); writer.Write((ushort)1);
            writer.Write((byte)0); writer.Write((byte)0); writer.Write((byte)0); writer.Write((byte)0);
            writer.Write((ushort)1); writer.Write((ushort)32);
            writer.Write((uint)iconPng.Length); writer.Write((uint)22); writer.Write(iconPng);
        }

        using (var bitmap = new Bitmap(1200, 630))
        using (var g = Graphics.FromImage(bitmap)) {
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.TextRenderingHint = System.Drawing.Text.TextRenderingHint.AntiAliasGridFit;
            using (var bg = new LinearGradientBrush(new Point(0, 0), new Point(1200, 630),
                Color.FromArgb(13, 22, 37), Color.FromArgb(29, 52, 68)))
                g.FillRectangle(bg, 0, 0, 1200, 630);
            using (var glow = new SolidBrush(Color.FromArgb(20, 109, 226, 197)))
                g.FillEllipse(glow, 720, -220, 650, 650);
            Logo(g, 128, 174, 232);
            using (var font = new Font("Microsoft YaHei", 94, FontStyle.Bold, GraphicsUnit.Pixel))
            using (var white = new SolidBrush(Color.FromArgb(237, 242, 250)))
                g.DrawString("听隙", font, white, 410, 221);
            using (var pen = new Pen(Color.FromArgb(118, 109, 226, 197), 4)) {
                pen.StartCap = LineCap.Round; pen.EndCap = LineCap.Round;
                var points = new PointF[76];
                for (int i = 0; i < points.Length; i++) {
                    float x = 420 + i * 8.5f;
                    float envelope = (float)Math.Pow(Math.Sin(i * Math.PI / (points.Length-1)), 2);
                    float y = 468 + envelope * 28f * (float)(Math.Sin(i * 0.56) + 0.35 * Math.Sin(i * 1.27));
                    points[i] = new PointF(x, y);
                }
                g.DrawLines(pen, points);
            }
            bitmap.Save(Path.Combine(directory, "封面.png"), ImageFormat.Png);
        }
    }
}
'@

[TingXiArt]::Generate($PSScriptRoot)
