# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-freebsd/freebsd-pf/freebsd-pf-6.0.ebuild,v 1.1 2006/04/01 16:43:51 flameeyes Exp $

inherit bsdmk freebsd flag-o-matic

DESCRIPTION="FreeBSD's base system libraries"
SLOT="0"
KEYWORDS="~x86-fbsd"

IUSE=""

# Crypto is needed to have an internal OpenSSL header
SRC_URI="mirror://gentoo/${USBIN}.tar.bz2
		mirror://gentoo/${SBIN}.tar.bz2
		mirror://gentoo/${CONTRIB}.tar.bz2
		mirror://gentoo/${LIBEXEC}.tar.bz2
		mirror://gentoo/${ETC}.tar.bz2"

RDEPEND=""
DEPEND="${RDEPEND}
	=sys-freebsd/freebsd-mk-defs-${RV}*
	=sys-freebsd/freebsd-sources-${RV}*
	=sys-freebsd/freebsd-headers-${RV}*"

S="${WORKDIR}"

SUBDIRS="libexec/ftp-proxy usr.sbin/authpf sbin/pfctl sbin/pflogd"

src_unpack() {
	freebsd_src_unpack

	ln -s "/usr/src/sys-${RV}" "${WORKDIR}/sys"
}

src_compile() {
	for dir in ${SUBDIRS}; do
		einfo "Starting make in ${dir}"
		cd "${S}/${dir}"
		mkmake || die "Make ${dir} failed"
	done
}

src_install() {
	for dir in ${SUBDIRS}; do
		einfo "Starting install in ${dir}"
		cd "${S}/${dir}"
		mkinstall || die "Install ${dir} failed"
	done

	cd ${WORKDIR}/etc
	insinto /etc
	doins pf.conf pf.os
}
