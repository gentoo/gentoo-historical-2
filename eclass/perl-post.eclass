# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2
# Author: Seemant Kulleen <seemant@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/perl-post.eclass,v 1.7 2002/07/27 18:28:00 aliz Exp $
# The perl-post eclass is designed to allow the ${installarchdir}/perllocal.pod
# file to be updated cleanly after perl and/or perl-modules are installed
# or removed.
ECLASS=perl-post
INHERITED="$INHERITED $ECLASS"

EXPORT_FUNCTIONS pkg_setup pkg_preinst pkg_postinst pkg_prerm pkg_postrm \
	perlinfo updatepod

ARCH_LIB=""
POD_DIR=""


perl-post_pkg_setup() {

	perlinfo
}


perl-post_pkg_preinst() {
	
	perlinfo
}

perl-post_pkg_postinst() {

	updatepod
}

perl-post_pkg_prerm() {
	
	updatepod
}

perl-post_pkg_postrm() {

	updatepod
}

perl-post_perlinfo() {

	if [ -f /usr/bin/perl ]
	then 
		eval `perl '-V:installarchlib'`
		ARCH_LIB=${installarchlib}

		eval `perl '-V:version'`
		POD_DIR="/usr/share/perl/gentoo-pods/${version}"
	fi

}

perl-post_updatepod() {
	perlinfo

	if [ -d "${POD_DIR}" ]
	then
		cat ${POD_DIR}/*.pod > ${ARCH_LIB}/perllocal.pod
	fi
}
