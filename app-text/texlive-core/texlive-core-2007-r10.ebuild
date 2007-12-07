# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/texlive-core/texlive-core-2007-r10.ebuild,v 1.3 2007/12/07 17:04:33 aballier Exp $

inherit eutils flag-o-matic toolchain-funcs libtool autotools texlive-common

PATCHLEVEL="2"
TEXMFD_VERSION="1"

DESCRIPTION="A complete TeX distribution"
HOMEPAGE="http://tug.org/texlive/"
SLOT="0"
LICENSE="GPL-2 LPPL-1.3c"

TEXLIVE_BASICBIN_CONTENTS="bin-bibtex bin-dialog bin-dvipsk bin-etex bin-getnonfreefonts bin-gsftopk bin-kpathsea bin-makeindex bin-metafont bin-mfware bin-pdftex bin-tetex bin-tex bin-texconfig lib-regex lib-zlib"

TEXLIVE_BINEXTRA_CONTENTS="bin-bibtex8 bin-chktex bin-ctie bin-cweb bin-detex bin-dtl bin-dvi2tty bin-dvicopy bin-dvidvi bin-dviljk bin-lacheck bin-patgen bin-pdftools bin-seetexk bin-texdoc bin-texware bin-thumbpdf bin-tie bin-tpic2pdftex bin-vpe bin-web bin-xpdf cweb mkind-english"

TEXLIVE_FONTBIN_CONTENTS="bin-afm2pl bin-fontware bin-ps2pkm fontinst mft"

TEXLIVE_CORE_EXTRA_BUILT_BINARIES="bin-xetex bin-aleph bin-omega"

TEXLIVE_CORE_INCLUDED_TEXMF="${TEXLIVE_BASICBIN_CONTENTS} ${TEXLIVE_FONTBIN_CONTENTS} ${TEXLIVE_BINEXTRA_CONTENTS} ${TEXLIVE_CORE_EXTRA_BUILT_BINARIES}"

SRC_URI="mirror://gentoo/${P}.tar.bz2"

for i in ${TEXLIVE_CORE_INCLUDED_TEXMF}; do
	SRC_URI="${SRC_URI} mirror://gentoo/texlive-module-${i}-${PV}.zip"
done

# Ship an updated config.ps, see bug #195815 comment 51
# Or alternatively: http://tug.org/texlive/bugs.html
SRC_URI="${SRC_URI} mirror://gentoo/${P}-updated-config.ps.bz2"

# Fetch patches
SRC_URI="${SRC_URI} mirror://gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2
	mirror://gentoo/${P}-texmf.d-${TEXMFD_VERSION}.tar.bz2"

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc64 ~sparc ~x86"
IUSE="X doc"

MODULAR_X_DEPEND="X? (
				x11-libs/libXmu
				x11-libs/libXp
				x11-libs/libXpm
				x11-libs/libICE
				x11-libs/libSM
				x11-libs/libXaw
				x11-libs/libXfont
	)"

DEPEND="${MODULAR_X_DEPEND}
	!app-text/ptex
	!app-text/cstetex
	!app-text/tetex
	!<app-text/texlive-2007
	!app-text/xetex
	!dev-tex/xmltex
	!dev-tex/vntex
	sys-apps/ed
	sys-libs/zlib
	>=media-libs/libpng-1.2.1
	app-arch/unzip
	=media-libs/freetype-2*
	media-libs/fontconfig"

RDEPEND="${DEPEND}
	dev-lang/ruby"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"

	sed -i -e "/mktexlsr/,+3d" -e "s/\(updmap-sys\)/\1 --nohash/" \
		Makefile.in || die "sed failed"

	elibtoolize

	cd libs/teckit
	eautoreconf

# Ship an updated config.ps, see bug #195815 comment 51
# Or alternatively: http://tug.org/texlive/bugs.html
	cp -f "${WORKDIR}/${P}-updated-config.ps" "${S}/texmf/dvips/config/config.ps"
}

src_compile() {
	local my_conf

	export LC_ALL=C
	tc-export CC CXX

	econf --bindir=/usr/bin \
		--datadir="${S}" \
		--with-system-freetype2 \
		--with-freetype2-include=/usr/include \
		--with-system-zlib \
		--with-system-pnglib \
		--without-texinfo \
		--without-dialog \
		--without-texi2html \
		--disable-multiplatform \
		--with-epsfwin \
		--with-mftalkwin \
		--with-regiswin \
		--with-tektronixwin \
		--with-unitermwin \
		--with-ps=gs \
		--without-psutils \
		--without-sam2p \
		--without-t1utils \
		--enable-ipc \
		--without-etex \
		--with-xetex \
		--without-dvipng \
		--without-dvipdfm \
		--without-dvipdfmx \
		--without-xdvipdfmx \
		--without-lcdf-typetools \
		--without-pdfopen \
		--without-ps2eps \
		--without-detex \
		--without-ttf2pk \
		--without-tex4htk \
		--without-cjkutils \
		--without-xdvik --without-oxdvik \
		--enable-shared \
		$(use_with X x) \
		${my_conf} || die "econf failed"

	cd "${S}/libs/icu-xetex"
	emake -j1 texmf=${TEXMF_PATH:-/usr/share/texmf} || die "emake of icu-xetex failed"
	cd "${S}"
	emake texmf=${TEXMF_PATH:-/usr/share/texmf} || die "emake failed"

	# Mimic updmap --syncwithtrees to enable only fonts installed
	# Code copied from updmap script
	for i in `egrep '^(Mixed)?Map' "texmf/web2c/updmap.cfg" | sed 's@.* @@'`; do
		texlive-common_is_file_present_in_texmf "$i" || echo "$i"
	done > "${T}/updmap_update"
	{
		sed 's@/@\\/@g; s@^@/^MixedMap[     ]*@; s@$@$/s/^/#! /@' <"${T}/updmap_update"
		sed 's@/@\\/@g; s@^@/^Map[  ]*@; s@$@$/s/^/#! /@' <"${T}/updmap_update"
	} > "${T}/updmap_update2"
	sed -f "${T}/updmap_update2" "texmf/web2c/updmap.cfg" >	"${T}/updmap_update3"\
		&& cat "${T}/updmap_update3" > "texmf/web2c/updmap.cfg"
}

src_test() {
	ewarn "Due to modular layout of texlive ebuilds,"
	ewarn "It would not make much sense to use tests into the ebuild"
	ewarn "And tests would fail anyway"
	ewarn "Alternatively you can try to compile any tex file"
	ewarn "Tex warnings should be considered as errors and reported"
	ewarn "You can also run fmtutil-sys --all and check for errors/warnings there"
}

src_install() {
	insinto /usr/share
	doins -r texmf texmf-dist

	dodir ${TEXMF_PATH:-/usr/share/texmf}/web2c
	einstall bindir="${D}/usr/bin" texmf="${D}${TEXMF_PATH:-/usr/share/texmf}" || die "einstall failed"

	dosbin "${FILESDIR}/texmf-update"

	docinto texk
	cd "${S}/texk"
	dodoc ChangeLog README

	docinto kpathesa
	cd "${S}/texk/kpathsea"
	dodoc BUGS ChangeLog NEWS PROJECTS README

	docinto dviljk
	cd "${S}/texk/dviljk"
	dodoc ChangeLog README NEWS

	docinto dvipsk
	cd "${S}/texk/dvipsk"
	dodoc ChangeLog README

	docinto makeindexk
	cd "${S}/texk/makeindexk"
	dodoc ChangeLog NEWS NOTES README

	docinto ps2pkm
	cd "${S}/texk/ps2pkm"
	dodoc ChangeLog README README.14m

	docinto web2c
	cd "${S}/texk/web2c"
	dodoc ChangeLog NEWS PROJECTS README

	use doc || rm -rf "${D}/usr/share/texmf/doc"
	use doc || rm -rf "${D}/usr/share/texmf-dist/doc"

	dodir /var/cache/fonts

	dodir /etc/env.d
	echo 'CONFIG_PROTECT_MASK="/etc/texmf/web2c"' > "${D}/etc/env.d/98texlive"
	# populate /etc/texmf
	keepdir /etc/texmf/web2c

	# take care of updmap.cfg, fmtutil.cnf and texmf.cnf
	dodir /etc/texmf/{updmap.d,fmtutil.d,texmf.d}

	# Remove fmtutil.cnf, it will be regenerated from /etc/texmf/fmtutil.d files
	# by texmf-update
	rm -f "${D}${TEXMF_PATH}/web2c/fmtutil.cnf"

	# Remove default texmf.cnf to ship our own, greatly based on texlive dvd's
	# texmf.cnf
	# It will also be generated from /etc/texmf/texmf.d files by texmf-update
	rm -f "${D}${TEXMF_PATH}/web2c/texmf.cnf"

	insinto /etc/texmf/texmf.d
	doins "${WORKDIR}/texmf.d/"*.cnf

	mv "${D}${TEXMF_PATH}/web2c/updmap.cfg"	"${D}/etc/texmf/updmap.d/00updmap.cfg" || die "moving updmap.cfg failed"

	# dvips config file
	keepdir /etc/texmf/dvips/config
	dodir /etc/texmf/dvips.d
	mv "${D}${TEXMF_PATH}/dvips/config/config.ps" "${D}/etc/texmf/dvips.d/00${PN}-config.ps" || die "moving config.ps failed"

	# Create symlinks from format to engines
	# This will avoid having to call texlinks in texmf-update
	cd "${S}"
	for i in texmf/fmtutil/format*.cnf; do
		[ -f "${i}" ] && etexlinks "${i}"
	done

	texlive-common_handle_config_files

	keepdir /usr/share/texmf-site

	dosym /etc/texmf/web2c/fmtutil.cnf ${TEXMF_PATH}/web2c/fmtutil.cnf
	dosym /etc/texmf/web2c/texmf.cnf ${TEXMF_PATH}/web2c/texmf.cnf
	dosym /etc/texmf/web2c/updmap.cfg ${TEXMF_PATH}/web2c/updmap.cfg
	dosym /etc/texmf/dvips/config/config.ps ${TEXMF_PATH}/dvips/config/config.ps

	# the virtex symlink is not installed
	# The links has to be relative, since the targets
	# is not present at this stage and MacOS doesn't
	# like non-existing targets
	dosym tex /usr/bin/virtex
	dosym pdftex /usr/bin/pdfvirtex
}

pkg_postinst() {
	if [ "$ROOT" = "/" ] ; then
		/usr/sbin/texmf-update
	fi

	elog
	elog "If you have configuration files in /etc/texmf to merge,"
	elog "please update them and run /usr/sbin/texmf-update."
	elog
}
