# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/mono.eclass,v 1.11 2009/01/05 17:12:34 loki_val Exp $

# @ECLASS: mono.eclass
# @MAINTAINER:
# dotnet@gentoo.org
# @BLURB: common settings and functions for mono and dotnet related
# packages
# @DESCRIPTION:
# The mono eclass contains common environment settings that are useful for
# dotnet packages.  Currently, it provides no functions, just exports
# MONO_SHARED_DIR and sets LC_ALL in order to prevent errors during compilation
# of dotnet packages.

inherit multilib

# >=mono-0.92 versions using mcs -pkg:foo-sharp require shared memory, so we set the
# shared dir to ${T} so that ${T}/.wapi can be used during the install process.
export MONO_SHARED_DIR="${T}"

# Building mono, nant and many other dotnet packages is known to fail if LC_ALL
# variable is not set to C. To prevent this all mono related packages will be
# build with LC_ALL=C (see bugs #146424, #149817)
export LC_ALL=C

# Monodevelop-using applications need this to be set or they will try to create config
# files in the user's ~ dir.

export XDG_CONFIG_HOME="${T}"

# Fix bug 83020:
# "Access Violations Arise When Emerging Mono-Related Packages with MONO_AOT_CACHE"

unset MONO_AOT_CACHE

egacinstall() {
	gacutil -i "${1}" \
		-root "${D}"/usr/$(get_libdir) \
		-gacdir /usr/$(get_libdir) \
		-package ${2:-${GACPN:-${PN}}} \
		|| die "installing ${1} into the Global Assembly Cache failed"
}

mono_multilib_comply() {
	local dir finddirs=()
	if [[ -d "${D}/usr/lib" && "$(get_libdir)" != "lib" ]]
	then
		if ! [[ -d "${D}"/usr/"$(get_libdir)" ]]
		then
			mkdir "${D}"/usr/"$(get_libdir)" || die "Couldn't mkdir ${D}/usr/$(get_libdir)"
		fi
		cp -ar "${D}"/usr/lib/* "${D}"/usr/"$(get_libdir)"/ || die "Moving files into correct libdir failed"
		rm -rf "${D}"/usr/lib
		for dir in "${D}"/usr/"$(get_libdir)"/pkgconfig "${D}"/usr/share/pkgconfig
		do
			[[ -d "${dir}" ]] && finddirs=( "${finddirs[@]}" "${dir}" )
		done
		if ! [[ -z "${finddirs[@]// /}" ]]
		then
			sed  -i -r -e 's:/(lib)([^a-zA-Z0-9]|$):/'"$(get_libdir)"'\2:g' \
				$(find "${finddirs[@]}" -name '*.pc') \
				|| die "Sedding some sense into pkgconfig files failed."
		fi

	fi
}
