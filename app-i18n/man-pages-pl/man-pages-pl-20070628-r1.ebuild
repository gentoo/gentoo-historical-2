# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/man-pages-pl/man-pages-pl-20070628-r1.ebuild,v 1.1 2011/07/30 17:08:55 nelchael Exp $

inherit autotools

DESCRIPTION="A collection of Polish translations of Linux manual pages."
HOMEPAGE="http://www.batnet.pl/ptm/"
SRC_URI="http://www.batnet.pl/ptm/man-PL${PV:6:2}-${PV:4:2}-${PV:0:4}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}/pl_PL"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# missing manpages
	sed -i -e '/\tpasswd.1/ d' man1/Makefile.am

	# manpages provided by other packages
	mans="gendiff.1 groups.1 apropos.1 man.1 su.1 newgrp.1 whatis.1 gpasswd.1 chsh.1 \
			chfn.1 limits.5 login.1 expiry.1 porttime.5 lastlog.8 faillog.8 logoutd.8 \
			rpm.8 rpmdeps.8 rpmbuild.8 rpmcache.8 rpmgraph.8 rpm2cpio.8 evim.1 vim.1 \
			vimdiff.1 vimtutor.1 ex.1 rview.1 rvim.1 view.1 suauth.5 mc.1"
	# bug #375623:
	mans="${mans} manpath.5 catman.8 mandb.8 zsoelim.1 manpath.1"
	for page in ${mans} ; do
		sed -i -e "/\\t${page}/ d" man${page: -1}/Makefile.am
	done

	eautoreconf || die
}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog FAQ NEWS README TODO
}
