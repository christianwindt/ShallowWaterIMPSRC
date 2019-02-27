%Run parameter study over wavemaker dimensions

lambda=15.9428
Depth=0.74
RelaxCentroid=[0.37];
RelaxCentroidX=31.8846;
RelaxLength=lambda.*[0.125 0.25];% 0.5 0.75 1];
RelaxHeight=Depth.*[1.25];



for i=RelaxCentroid
	for j=RelaxLength
		for k=RelaxHeight
			%Copy master case to new name
            Casename=strcat('Centr' ,num2str(i),'Length',num2str(j) ,'Height',num2str(k));
            cmd=strcat('cp -r caseMaster  \',Casename );
             system(cmd);
			%Set parameters
            RXmin =RelaxCentroidX-j/2;
            RXmax=RelaxCentroidX+j/2;
            RZmin=i-k/2;
            RZmax=i+k/2;
            
            cmd=strcat('sed -i s/RXmin/',num2str(RXmin),'/g \',Casename ,'/system/setFieldsDict' );
            system(cmd);
            cmd=strcat('sed -i s/RXmax/',num2str(RXmax),'/g \',Casename ,'/system/setFieldsDict' );
            system(cmd);
            cmd=strcat('sed -i s/RZmin/',num2str(RZmin),'/g \',Casename ,'/system/setFieldsDict' );
            system(cmd);
            cmd=strcat('sed -i s/RZmax/',num2str(RZmax),'/g \',Casename ,'/system/setFieldsDict' );
            system(cmd);

			%Run calibration, not sure how you run those on your cluster
           cmd=strcat('cd \',Casename,'; ./Allclean; ./Allrun') ;
           system(cmd);
           %cmd=strcat('cd \',Casename,'; octave NewWave.m') ;
           %system(cmd);
           cmd=strcat('cd \',Casename,'; octave createfirstinput.m') ;
           system(cmd);
           cmd=strcat('cd \',Casename,'; octave calibtracefrequmethod.m') ;
           system(cmd);
            %   
               
		end
	end
end

