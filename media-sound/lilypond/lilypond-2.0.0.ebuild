# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/lilypond/lilypond-2.0.0.ebuild,v 1.2 2003/10/01 15:34:49 agriffis Exp $

IUSE="doc"

MY_PV="v$(echo ${PV} | cut -d. -f1,2)"
DESCRIPTION="GNU Music Typesetter"
SRC_URI="http://www.lilypond.org/ftp/${MY_PV}/${P}.tar.gz"
HOMEPAGE="http://lilypond.org/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~x86"

DEPEND=">=dev-lang/python-2.2.3-r1
	>=dev-lang/perl-5.8.0-r12
	>=dev-util/guile-1.6.4
	>=app-text/tetex-1.0.7-r12
	>=sys-apps/texinfo-4.6
	>=sys-devel/flex-2.5.4a-r5
	>=sys-devel/gcc-3.1-r8
	>=sys-devel/make-3.80
	>=app-text/mftrace-1.0.19
	>=app-text/ghostscript-7.05.6-r3
	|| (
		=sys-devel/bison-1.35*
		>=sys-devel/bison-1.875
	)
	doc? ( media-gfx/imagemagick
		>=media-libs/netpbm-9.12-r4 )"

RDEPEND=">=dev-util/guile-1.6.4
	>=app-text/ghostscript-7.05.6-r3
	>=app-text/tetex-1.0.7-r12
	>=dev-lang/python-2.2.3-r1"

src_unpack() {
	unpack ${A} || die "unpack failed"
	cd ${S}; epatch ${FILESDIR}/${P}-coreutils-compat.patch
	NOCONFIGURE=1 ./autogen.sh >/dev/null
}

src_compile() {
	# Remove ccache from the PATH since it can break compilation of
	# this package.  See bug 21305
	PATH="$(echo ":${PATH}:" | sed 's/:[^:]*ccache[^:]*:/:/;s/^://;s/:$//;')"

	addwrite /dev/stderr
	addwrite /var/cache/fonts
	addwrite /usr/share/texmf/fonts
	addwrite /usr/share/texmf/ls-R

	econf --build=${CHOST} || die "econf failed"
	emake || die "emake failed"

	if use doc; then
		make web || die "make web failed"
	fi
}

src_install () {
	einstall \
		lilypond_datadir=${D}/usr/share/lilypond \
		local_lilypond_datadir=${D}/usr/share/lilypond/${PV} \
		|| die "einstall failed"

	dodoc AUTHORS.txt COPYING ChangeLog DEDICATION INSTALL.txt \
		NEWS.txt README.txt ROADMAP THANKS VERSION \
		|| die "dodoc failed"

	insinto /usr/share/lilypond/${PV}/buildscripts/out
	doins buildscripts/out/lilypond-profile \
		buildscripts/out/lilypond-login \
		buildscripts/out/clean-fonts \
		buildscripts/out/lilypond.words \
		|| die "doins failed"
	insinto /usr/share/lilypond/${PV}/elisp/out
	doins elisp/out/lilypond.words.el elisp/out/lilypond.words.vim \
		|| die "doins failed"
	insinto /usr/share/lilypond/${PV}/elisp
	doins elisp/*.el \
		|| die "doins failed"
	insinto /usr/share/lilypond/${PV}/
	doins lilypond.vim vimrc \
		|| die "doins failed"

	# we might be able to get the new "make out=www web-install"
	# to work (if someone wants to fight with it), but our
	# old way is easier for now:
	if use doc; then
		dohtml -A txt,midi,ly,pdf,gz -r Documentation input *.html *.png \
		|| die "doins failed"
	fi
}

pkg_postinst () {
	# Cleaning out old fonts is more appropriate in pkg_prerm, but we
	# also need to clean up after any previous lilypond installations.
	. /usr/share/lilypond/${PV}/buildscripts/out/clean-fonts
}

pkg_prerm () {
	. /usr/share/lilypond/${PV}/buildscripts/out/clean-fonts
}
