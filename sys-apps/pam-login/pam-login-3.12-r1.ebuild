# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pam-login/pam-login-3.12-r1.ebuild,v 1.4 2004/04/27 04:55:47 vapier Exp $

inherit gnuconfig eutils

# Do we want to backup an old login.defs, and forcefully
# install a new version?
FORCE_LOGIN_DEFS="no"

MY_PN="${PN/pam-/pam_}"
S="${WORKDIR}/${MY_PN}-${PV}"
DESCRIPTION="Based on the sources from util-linux, with added pam and shadow features"
HOMEPAGE="http://www.thkukuk.de/pam/pam_login/"
SRC_URI="ftp://ftp.suse.com/pub/people/kukuk/pam/${MY_PN}/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha arm ~hppa ~amd64"
IUSE="nls"

DEPEND="virtual/glibc
	sys-libs/pam
	>=sys-apps/shadow-4.0.2-r5"

src_unpack() {
	unpack ${A}

	cd ${S}

	# Do not warn on inlining for gcc-3.3, bug #21213
	epatch ${FILESDIR}/${PN}-3.11-gcc33.patch

	epatch ${FILESDIR}/pam-login-3.11-lastlog-fix.patch
}

src_compile() {

	# Fix configure scripts to recognize linux-mips
	# (imports updated config.sub and config.guess)
	gnuconfig_update

	local myconf=
	use nls ||myconf="--disable-nls"

	econf ${myconf} || die

	emake || die
}

src_install() {
	einstall rootexecbindir=${D}/bin || die

	# We use the one from shadow
	rm -rf ${D}/etc/pam.d

	insinto /etc
	insopts -m0644

	doins ${FILESDIR}/login.defs
	# Also install another one that we can use to check if
	# we need to update it if FORCE_LOGIN_DEFS = "yes"
	[ "${FORCE_LOGIN_DEFS}" = "yes" ] \
		&& newins ${FILESDIR}/login.defs login.defs.new

	dodoc AUTHORS COPYING ChangeLog NEWS README THANKS
}

pkg_preinst() {
	rm -f ${ROOT}/etc/login.defs.new
}

pkg_postinst() {
	[ "${FORCE_LOGIN_DEFS}" != "yes" ] && return 0

	ewarn "Due to a compatibility issue, ${ROOT}etc/login.defs "
	ewarn "is being updated automatically. Your old login.defs"
	ewarn "will be backed up as:  ${ROOT}etc/login.defs.bak"
	echo

	local CHECK1="`md5sum ${ROOT}/etc/login.defs | cut -d ' ' -f 1`"
	local CHECK2="`md5sum ${ROOT}/etc/login.defs.new | cut -d ' ' -f 1`"

	if [ "${CHECK1}" != "${CHECK2}" ]
	then
		cp -a ${ROOT}/etc/login.defs ${ROOT}/etc/login.defs.bak
		mv -f ${ROOT}/etc/login.defs.new ${ROOT}/etc/login.defs
	elif [ ! -f ${ROOT}/etc/login.defs ]
	then
		mv -f ${ROOT}/etc/login.defs.new ${ROOT}/etc/login.defs
	else
		rm -f ${ROOT}/etc/login.defs.new
	fi
}

