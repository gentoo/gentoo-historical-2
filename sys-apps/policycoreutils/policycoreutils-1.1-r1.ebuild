# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/policycoreutils/policycoreutils-1.1-r1.ebuild,v 1.3 2003/09/23 04:26:43 pebenito Exp $

IUSE=""

DESCRIPTION="SELinux core utilites"
HOMEPAGE="http://www.nsa.gov/selinux"
SRC_URI="http://www.nsa.gov/selinux/archives/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"

DEPEND="sys-libs/libselinux
	sys-apps/attr
	sys-libs/pam"

RDEPEND="${DEPEND}
	sys-apps/mkinitrd"

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${PN}-1.0-gentoo.diff
	epatch ${FILESDIR}/${P}-setfiles.diff

	# overwrite the /etc/pam.d files with ones
	# that work with our pam setup
	cp -f ${FILESDIR}/newrole ${S}/newrole/newrole.pamd
	cp -f ${FILESDIR}/run_init ${S}/run_init/run_init.pamd
}

src_compile() {
	SUBDIRS="load_policy newrole run_init setfiles"

	for i in ${SUBDIRS}; do
		einfo "Compiling ${i}"
		cd ${S}/${i}
		emake EXTRA_CFLAGS="${CFLAGS}"
	done
}

src_install() {
	make DESTDIR="${D}" install

	dosbin ${FILESDIR}/rlpkg
	dobin ${FILESDIR}/{avc_enforcing,avc_toggle}
}
