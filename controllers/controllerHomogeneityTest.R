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

doGetHomogeneityTestWithinDof = function(data)
{
  n = doGetHomogeneityNumOfValues(data)
  k = doGetHomogeneityNumCols(data)
  return(n-k)
}

doGetHomogeneityTestBetweenDof = function(data)
{
  k = doGetHomogeneityNumCols(data)
  return(k-1)
}

doGetHomogeneityTestFCritical = function(data, alphaValue)
{
  bDof = doGetHomogeneityTestBetweenDof(data)
  wDof = doGetHomogeneityTestWithinDof(data)
  
  #Alpha value of 0.05 requires 0.95 to be entered into QF function
  return(qf(1-alphaValue, bDof, wDof))
}

doGetHomogeneityTestPass = function(data, alphaValue)
{
  fCrit = doGetHomogeneityTestFCritical(data, alphaValue)
  fValue = doGetHomogeneityFValue(data)
  
  if(fValue >= fCrit)
  {
    return(FALSE)
  }
  return(TRUE)
}