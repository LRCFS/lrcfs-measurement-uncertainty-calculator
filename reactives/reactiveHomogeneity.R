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

getDataHomogeneity = reactive({
  if(myReactives$uploadedHomogeneity == TRUE)
  {
    data = homogeneityReadCSV(input$inputHomogeneityFileUpload$datapath)
    return(data)
  }
  else
  {
    return(NULL)
  }
})

getDataHomogeneityCalcs = reactive({
  data = doGetDataHomogeneityCalcs(getDataHomogeneity())
  return(data)
})


getHomogeneity_degreesOfFreedom = reactive({
  if(myReactives$uploadedHomogeneity == FALSE)
  {
    return(NA)
  }
  else
  {
    return("\\infty")
  }
})

getHomogeneity_standardUncerainty = reactive({
  data = getDataHomogeneity()
  return(doGetHomogeneity_standardUncerainty(data))
})

getHomogeneity_relativeStandardUncertainty = reactive({
  data = getDataHomogeneity()
  return(doGetHomogeneity_relativeStandardUncertainty(data))
})


