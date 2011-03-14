# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/fortran.eclass,v 1.22 2011/03/14 17:16:30 jlec Exp $
#
# Author: Danny van Dyk <kugelfang@gentoo.org>
#

# @DEPRECATED
# This eclass has been superseded by functions in toolchain-funcs.eclass:
# Please use tc-getFC to set the fortran compiler!
# https://bugs.gentoo.org/348851

ewarn "The fortran.eclass is deprecated! Please use the toolchains-funcs.eclass"
ewarn "https://bugs.gentoo.org/348851"

inherit eutils autotools

DESCRIPTION="Based on the ${ECLASS} eclass"

IUSE="debug"

#DEPEND="virtual/fortran" # Let's aim for this...

# Which Fortran Compiler has been selected ?
export FORTRANC

# These are the options to ./configure / econf that enable the usage
# of a specific Fortran Compiler. If your package uses a different
# option that the one listed here, overwrite it in your ebuild.
g77_CONF="--with-f77"
f2c_CONF="--with-f2c"

# This function prints the necessary options for the currently selected
# Fortran Compiler.
fortran_conf() {
	echo $(eval echo \${$(echo -n ${FORTRANC})_CONF})
}

# need_fortran(<profiles>):
#  profiles = <profile> ... <profile>
#
#  profile:
#   * gfortran - GCC Fortran 95
#   * g77 - GCC Fortran 77
#   * f2c - Fortran 2 C Translator
#   * ifc - Intel Fortran Compiler
#   * f95 - Sun Studio Fortran Compiler
#
# Checks if at least one of <profiles> is installed.
# Checks also if F77 (the fortran compiler to use) is available
# on the System.
need_fortran() {
	if [ -z "$*" ]; then
		eerror "Call need_fortran with at least one argument !"
	fi
	local AVAILABLE
	local PROFILE
	for PROFILE in $@; do
		case ${PROFILE} in
			gfortran)
				if [ -x "$(type -P gfortran 2> /dev/null)" ]; then
					AVAILABLE="${AVAILABLE} gfortran"
				fi
				;;
			g77)
				if [ -x "$(type -P g77 2> /dev/null)" ]; then
					AVAILABLE="${AVAILABLE} g77"
				fi
				;;
			f2c)
				if [ -x "$(type -P f2c 2> /dev/null)" ]; then
					AVAILABLE="${AVAILABLE} f2c"
				fi
				;;
			ifc)
				case ${ARCH} in
					x86|ia64|amd64)
						if [ -x "$(type -P ifort 2> /dev/null)" ]; then
							AVAILABLE="${AVAILABLE} ifort"
						elif [ -x "$(type -P ifc 2> /dev/null)" ]; then
							AVAILABLE="${AVAILABLE} ifc"
						fi
						;;
					*)
						;;
				esac
				;;
			f95)
				case ${ARCH} in
					x86|amd64)
						if [ -x "$(type -P f95 2> /dev/null)" ]; then
							AVAILABLE="${AVAILABLE} f95"
						fi
						;;
					*)
						;;
				esac
				;;
		esac
	done
	AVAILABLE="${AVAILABLE/^[[:space:]]}"
	use debug && echo ${AVAILABLE}
	if [ -z "${AVAILABLE}" ]; then
		eerror "None of the needed Fortran Compilers ($@) is installed."
		eerror "To install one of these, choose one of the following steps:"
		i=1
		for PROFILE in $@; do
			case ${PROFILE} in
				gfortran)
					eerror "[${i}] USE=\"fortran\" emerge =sys-devel/gcc-4*"
					;;
				g77)
					eerror "[${i}] USE=\"fortran\" emerge =sys-devel/gcc-3*"
					;;
				f2c)
					eerror "[${i}] emerge dev-lang/f2c"
					;;
				ifc)
					case ${ARCH} in
						x86|ia64)
							eerror "[${i}] emerge dev-lang/ifc"
							;;
						*)
							;;
					esac
					;;
				f95)
					case ${ARCH} in
						x86|amd64)
							eerror "[${i}] emerge dev-lang/sunstudio"
							;;
						*)
							;;
					esac
					;;
			esac
			i=$((i + 1))
		done
		die "Install a Fortran Compiler !"
	else
		einfo "You need one of these Fortran Compilers: $@"
		einfo "Installed are: ${AVAILABLE}"
		if [ -n "${F77}" -o -n "${FC}" -o -n "${F2C}" ]; then
			if [ -n "${F77}" ]; then
				FC="${F77}"						# F77 overwrites FC
			fi
			if [ -n "${FC}" -a -n "${F2C}" ]; then
				ewarn "Using ${FC} and f2c is impossible. Disabling F2C !"
				F2C=""							# Disabling f2c
				MY_FORTRAN="$(basename ${FC})"	# set MY_FORTRAN to filename of
												# the Fortran Compiler
			else
				if [ -n "${F2C}" ]; then
					MY_FORTRAN="$(basename ${F2C})"
				elif [ -n "${FC}" ]; then
					MY_FORTRAN="$(basename ${FC})"
				else
					MY_FORTRAN="$(basename ${F77})"
				fi
			fi
		fi

		# default to gfortran if available, g77 if not
		use debug && echo "MY_FORTRAN: \"${MY_FORTRAN}\""
		if hasq gfortran ${AVAILABLE}; then
			MY_FORTRAN=${MY_FORTRAN:=gfortran}
		elif hasq g77 ${AVAILABLE}; then
			MY_FORTRAN=${MY_FORTRAN:=g77}
		else
			# Default to the first valid Fortran compiler
			for i in ${AVAILABLE}; do
				MY_FORTRAN=$i
				break
			done
		fi
		use debug && echo "MY_FORTRAN: \"${MY_FORTRAN}\""

		if ! hasq ${MY_FORTRAN} ${AVAILABLE}; then
			eerror "Current Fortran Compiler is set to ${MY_FORTRAN}, which is not usable with this package !"
			die "Wrong Fortran Compiler !"
		fi

		case ${MY_FORTRAN} in
			gfortran|g77|ifc|ifort|f2c|f95)
				FORTRANC="${MY_FORTRAN}"
		esac
	fi
	use debug && echo "FORTRANC: \"${FORTRANC}\""
}

# patch_fortran():
#  Apply necessary patches for ${FORTRANC}
patch_fortran() {
	if [[ -z "${FORTRANC}" || ! -d "${FILESDIR}" ]]; then
		return
	fi
	local PATCHES=$(find ${FILESDIR} -name "${P}-${FORTRANC}-*")
	einfo "Applying patches for selected FORTRAN compiler: ${FORTRANC}"
	local PATCH
	if [ -n "${PATCHES}" ]; then
		for PATCH in ${PATCHES}; do
			epatch ${PATCH}
		done
		eautoreconf
	fi
}

# fortran_pkg_setup():
#  Set FORTRAN to indicate the list of Fortran Compiler that
#  can be used for the ebuild.
#  If not set in ebuild, FORTRAN will default to f77
fortran_pkg_setup() {
	need_fortran ${FORTRAN:="gfortran g77"}
}

# fortran_src_unpack():
#  Run patch_fortran if no new src_unpack() is defined.
fortran_src_unpack() {
	unpack ${A}
	cd "${S}"
	patch_fortran
}

EXPORT_FUNCTIONS pkg_setup src_unpack
