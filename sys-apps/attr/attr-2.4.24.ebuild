# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/attr/attr-2.4.24.ebuild,v 1.5 2006/01/27 13:13:44 gustavoz Exp $

inherit eutils

DESCRIPTION="Extended attributes tools"
HOMEPAGE="http://oss.sgi.com/projects/xfs/"
SRC_URI="ftp://oss.sgi.com/projects/xfs/download/cmd_tars/${P}.src.tar.gz
	ftp://xfs.org/mirror/SGI/cmd_tars/${P}.src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 m68k ~mips ppc ~ppc64 s390 sh sparc ~x86"
IUSE="nls debug"

DEPEND=">=sys-apps/portage-2.0.47-r10
	nls? ( sys-devel/gettext )
	sys-devel/libtool"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-only-symlink-when-needed.patch
	sed -i \
		-e "/^PKG_DOC_DIR/s:=.*:= /usr/share/doc/${PF}:" \
		include/builddefs.in \
		|| die "failed to update builddefs"
}

src_compile() {
	use debug \
		&& export DEBUG=-DDEBUG \
		|| export DEBUG=-DNDEBUG
	export OPTIMIZER=${CFLAGS}

	econf \
		$(use_enable nls gettext) \
		--libexecdir=/usr/$(get_libdir) \
		--bindir=/bin \
		|| die
	emake || die
}

src_install() {
	make DIST_ROOT="${D}" install install-lib install-dev || die
	# the man-pages packages provides the man2 files
	rm -r "${D}"/usr/share/man/man2
	prepalldocs

	# move shared libs to /
	dodir /$(get_libdir)
	mv "${D}"/usr/$(get_libdir)/libattr.so* "${D}"/$(get_libdir)/ || die
	gen_usr_ldscript libattr.so
}
