# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdrdao/cdrdao-1.1.8.ebuild,v 1.12 2004/07/14 14:01:00 lv Exp $

inherit flag-o-matic eutils gcc

DESCRIPTION="Burn CDs in disk-at-once mode -- with optional GUI frontend"
HOMEPAGE="http://cdrdao.sourceforge.net/"
SRC_URI="mirror://sourceforge/cdrdao/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc hppa amd64"
IUSE="gnome"

RDEPEND="gnome? ( >=dev-cpp/gtkmm-2.0
	              >=dev-cpp/libgnomeuimm-2.0 )
	>=media-sound/lame-3.90"
DEPEND=">=dev-util/pccts-1.33.24-r1
	>=app-cdr/cdrtools-2.01_alpha20
	${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${PV}-gcc34.patch
	if ([ "`gcc-major-version`" -ge "3" -a "`gcc-minor-version`" -ge "4" ] && use gnome); then
		eerror "xdao current will not compile using gcc 3.4. in order to compile"
		eerror "and install cdrdao, you will have to USE="-gnome". a simple way"
		eerror "to do this via portage is to:"
		einfo "mkdir -p /etc/portage"
		einfo "echo \"app-cdr/cdrdao -gnome\" >> /etc/portage/package.use"
		die "xdao wont compile using gcc 3.4"
	fi

	# Only way to disable gcdmaster currently ...
	use gnome || \
		sed -i -e 's:^en_xdao=yes:en_xdao=no:g' configure
}

src_compile() {
	# -funroll-loops do not work
	filter-flags "-funroll-loops"

	./configure --build="${CHOST}"\
		--host="${CHOST}" \
		--prefix=/usr \
		`use_with gnome gnome` || die "configure failed"

	emake || die
}

src_install() {
	einstall

	cd ${S}

	# Desktop Icon
	if use gnome
	then
		insinto /usr/share/pixmaps
		doins xdao/stock/gcdmaster.png
		insinto /usr/share/gnome/apps/Applications
		doins ${FILESDIR}/gcdmaster.desktop
	fi

	# Documentation
	dodoc AUTHORS CREDITS ChangeLog NEWS README*
}
