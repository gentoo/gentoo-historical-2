# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/snd/snd-7.15.ebuild,v 1.1 2005/10/04 13:49:09 matsuu Exp $

IUSE="X alsa esd fam fftw gsl gtk guile jack ladspa motif nls opengl ruby"

S="${WORKDIR}/${P/\.*//}"
DESCRIPTION="Snd is a sound editor"
HOMEPAGE="http://ccrma.stanford.edu/software/snd/"
SRC_URI="ftp://ccrma-ftp.stanford.edu/pub/Lisp/${P}.tar.gz"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="media-libs/audiofile
	X? ( virtual/x11 )
	alsa? ( media-libs/alsa-lib )
	esd? ( media-sound/esound )
	fam? ( virtual/fam )
	fftw? ( sci-libs/fftw )
	gsl? ( >=sci-libs/gsl-0.8 )
	gtk? ( >=x11-libs/gtk+-2 )
	guile? ( >=dev-util/guile-1.3.4 )
	jack? ( media-sound/jack )
	ladspa? ( media-libs/ladspa-sdk )
	motif? ( x11-libs/openmotif )
	nls? ( sys-devel/gettext )
	opengl? ( virtual/opengl )
	ruby? ( virtual/ruby )"

src_compile() {
	local myconf

	if use opengl; then
		if use guile; then
			myconf="${myconf} --with-gl"
		else
			myconf="${myconf} --with-just-gl"
		fi
	else
		myconf="${myconf} --without-gl"
	fi

	econf \
		$(use_with X x) \
		$(use_with alsa) \
		$(use_with esd) \
		$(use_with fam) \
		$(use_with fftw) \
		$(use_with gsl) \
		$(use_with gtk) \
		$(use_with guile) \
		$(use_with jack) \
		$(use_with ladspa) \
		$(use_with motif) \
		$(use_enable nls) \
		$(use_with ruby) \
		--with-float-samples \
		${myconf} || die

	emake || die
}

src_install () {
	dobin snd

	insinto /usr/$(get_libdir)/snd/scheme
	doins *.scm

	dodoc README.Snd HISTORY.Snd TODO.Snd Snd.ad
	dohtml -r *.html *.png tutorial
}
