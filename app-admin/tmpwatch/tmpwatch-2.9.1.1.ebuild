# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/tmpwatch/tmpwatch-2.9.1.1.ebuild,v 1.8 2004/12/28 11:46:55 ka0ttic Exp $

inherit versionator

RPM_P="${PN}-$(replace_version_separator 3 '-')"
MY_P="${RPM_P%-*}"

DESCRIPTION="Utility recursively searches through specified directories and removes files which have not been accessed in a specified period of time."
HOMEPAGE="http://download.fedora.redhat.com/pub/fedora/linux/core/development/SRPMS/"
SRC_URI="mirror://gentoo/${MY_P}-0.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc alpha ~ia64 amd64 ~ppc64"
IUSE=""

DEPEND="virtual/libc
	app-arch/rpm2targz"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	cd "${WORKDIR}"
	rpm2targz "${DISTDIR}/${MY_P}-0.src.rpm" || die "rpm2targz failed"
	tar zxf "${MY_P}-0.src.tar.gz" || die
	tar zxf "${MY_P}.tar.gz" || die

	cd "${S}"
	sed -i -e "s:..RPM_OPT_FLAGS.:${CFLAGS}:" \
		-e "s:^CVS:#CVS:g" Makefile \
		|| die "sed Makefile failed"
	sed -i 's|/sbin/fuser|/bin/fuser|' tmpwatch.c \
		|| die "sed tmpwatch.c failed"
	sed -i 's|/sbin|/bin|' tmpwatch.8 || die "sed tmpwatch.8 failed"
}

src_install() {
	preplib
	dosbin tmpwatch || die "dosbin failed"
	doman tmpwatch.8 || die "doman failed"

	exeinto /etc/cron.daily
	newexe "${FILESDIR}/${PN}.cron" "${PN}" || die
}
