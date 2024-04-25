function ew = ponderarW(e)

w=[-134, -374, 0, 2054, 5741, 8192, 5741, 2054, 0, -374, -134]/power(2,13);

ew = conv(e, w, 'same');