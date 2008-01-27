# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/krusader/krusader-1.80.0.ebuild,v 1.3 2008/01/27 15:47:52 philantrop Exp $

inherit kde

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="An advanced twin-panel (commander-style) file-manager for KDE with many extras."
HOMEPAGE="http://krusader.sourceforge.net/"
SRC_URI="mirror://sourceforge/krusader/${MY_P}.tar.gz
	mirror://gentoo/kde-admindir-3.5.3.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="javascript kde"

DEPEND="kde? ( || ( ( =kde-base/libkonq-3.5* =kde-base/kdebase-kioslaves-3.5* )
			=kde-base/kdebase-3.5* ) )
	!sparc? ( javascript? ( =kde-base/kjsembed-3.5* ) )"

RDEPEND="${DEPEND}"

need-kde 3.4

pkg_postinst() {
	echo
	elog "Krusader can use some external applications, including:"
	elog
	elog "Tools"
	elog "- eject   (sys-apps/eject)"
	elog "- locate  (sys-apps/slocate)"
	elog "- kdiff3  (kde-misc/kdiff3)"
	elog "- kompare (kde-base/kompare)"
	elog "- xxdiff  (dev-util/xxdiff)"
	elog "- krename (kde-misc/krename)"
	elog "- kmail   (kde-base/kmail)"
	elog "- kget    (kde-base/kget)"
	elog "- kdesu   (kde-base/kdesu)"
	elog
	elog "Packers"
	elog "- arj     (app-arch/arj)"
	elog "- unarj   (app-arch/unarj)"
	elog "- rar     (app-arch/rar)"
	elog "- unrar   (app-arch/unrar)"
	elog "- zip     (app-arch/zip)"
	elog "- unzip   (app-arch/unzip)"
	elog "- unace   (app-arch/unace)"
	elog "- lha     (app-arch/lha)"
	elog "- rpm     (app-arch/rpm)"
	elog "- dpkg    (app-arch/dpkg)"
	elog "- 7zip    (app-arch/p7zip)"
	elog
	elog "Checksum Tools"
	elog "- cfv     (app-arch/cfv)"
	elog "- md5deep (app-crypt/md5deep)"
	echo
}

src_unpack() {
	# Don't use kde_src_unpack or the new admindir updating code
	# will reset admindir before the configure.in.bot change is fixed.
	unpack ${A}

	# Stupid thing to do, but upstream did it
	mv "${S}/admin/configure.in.bot.end" "${S}/configure.in.bot"

	rm -rf "${S}/admin" "${S}/configure"
	ln -s "${WORKDIR}/admin" "${S}/admin"
}

src_compile() {
	local myconf="$(use_with kde konqueror) $(use_with javascript) --with-kiotar"
	kde_src_compile
}
