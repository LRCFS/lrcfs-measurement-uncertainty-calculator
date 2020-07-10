###########################################################################
#
# Measurement Uncertainty Calculator - Copyright (C) 2019
# Leverhulme Research Centre for Forensic Science
# Roy Mudie, Joyce Klu, Niamh Nic Daeid
# Website: https://github.com/LRCFS/lrcfs-measurement-uncertainty-calculator/
# Contact: lrc@dundee.ac.uk
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
###########################################################################

getDataSampleVolume = reactive({
  if(myReactives$uploadedSampleVolume == TRUE)
  {
    data = sampleVolumeReadCSV(input$inputSampleVolumeFileUpload$datapath)
    return(data)
  }
  else
  {
    return(NULL)
  }
})

getResultSampleVolume = reactive ({
  data = getDataSampleVolume()
  if(is.null(data)) return(NA)
  
  answer = doGetSampleVolume_result(data)
  return(answer)
})

getSampleVolume_degreesOfFreedom = reactive({
  if(myReactives$uploadedSampleVolume == FALSE)
  {
    return(NA)
  }
  else
  {
    return("\\infty")
  }
})

getSampleVolume_standardUncerainty = reactive({
  data = getDataSampleVolume()
  return(doGetSampleVolume_standardUncerainty(data))
})

getSampleVolume_relativeStandardUncertainty = reactive({
  data = getDataSampleVolume()
  return(doGetSampleVolume_relativeStandardUncertainty(data))
})


