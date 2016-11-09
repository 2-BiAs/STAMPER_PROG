sFeed = "F(P7)";
fTotalTime = 0;
fTotalLength = 0;
for i = 2:size(listCompedCutPath, 1)
    if sFeed ~= sLineEndCode(i) & sLineEndCode(i) ~= "" then
        sFeed = sLineEndCode(i);
    end
    select sFeed
    case "F(P7)"
        fFeed = 20
    case "F(P8)"
        fFeed = 5
    case "F(P9)"
        fFeed = 100
    end
    printf("%f\n", fFeed)
    fSegmentLength = norm(listCompedCutPath(i, :) - listCompedCutPath(i-1, :));
    fTotalTime = fTotalTime + fSegmentLength / fFeed;
    fTotalLength = fTotalLength + fSegmentLength;
end

printf("TotalTime = %f     TotalLength = %f", fTotalTime, fTotalLength);
