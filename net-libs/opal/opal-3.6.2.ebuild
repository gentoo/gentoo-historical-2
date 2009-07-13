# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/opal/opal-3.6.2.ebuild,v 1.4 2009/07/13 20:23:49 volkmar Exp $

EAPI="2"

inherit eutils autotools toolchain-funcs java-pkg-opt-2

DESCRIPTION="C++ class library normalising numerous telephony protocols"
HOMEPAGE="http://www.opalvoip.org/"
SRC_URI="mirror://sourceforge/opalvoip/${P}.tar.bz2
	doc? ( mirror://sourceforge/opalvoip/${P}-htmldoc.tar.bz2 )"

LICENSE="MPL-1.0"
SLOT="0"
KEYWORDS="~alpha ~ppc ~x86"
IUSE="+audio capi debug dns doc dtmf examples fax ffmpeg h224 h281 h323 iax ipv6
ivr ixj java ldap lid +plugins rfc4175 sbc sip sipim srtp ssl stats swig theora
+video vpb vxml wav x264 x264-static xml"

RDEPEND=">=net-libs/ptlib-2.0.0[stun,url,debug=,audio?,dns?,dtmf?,ipv6?,ldap?,ssl?,video?,vxml?,wav?,xml?]
	>=media-libs/speex-1.2_beta
	fax? ( net-libs/ptlib[asn] )
	h323? ( net-libs/ptlib[asn] )
	ivr? ( net-libs/ptlib[xml,vxml] )
	java? ( >=virtual/jre-1.4 )
	plugins? ( dev-libs/ilbc-rfc3951
		media-sound/gsm
		capi? ( net-dialup/capi4k-utils )
		ffmpeg? ( >=media-video/ffmpeg-0.4.7[encode] )
		ixj? ( sys-kernel/linux-headers )
		sbc? ( media-libs/libsamplerate )
		theora? ( media-libs/libtheora )
		x264? (	>=media-video/ffmpeg-0.4.7
			media-libs/x264 ) )
	srtp? ( net-libs/libsrtp )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/gcc-3
	java? ( swig? ( dev-lang/swig[java] )
		>=virtual/jdk-1.4 )"

# NOTES:
# ffmpeg[encode] is for h263 and mpeg4
# ssl, xml, vxml, ipv6, dtmf, ldap, audio, wav, dns and video are use flags
#   herited from ptlib: feature is enabled if ptlib has enabled it
#   however, disabling it if ptlib has it looks hard (coz of buildopts.h)
#   forcing ptlib to disable it for opal is not a solution too
#   atm, accepting the "auto-feature" looks like a good solution
#   (asn is used for fax and config _only_ for examples)
# OPALDIR should not be used anymore but if a package still need it, create it

# TODO:
# force or merge some non-plugin USE flags wo/ deps ?
# celt is not in the tree and should be added

conditional_use_error_msg() {
	eerror "To enable ${1} USE flag, you need ${2} USE flag to be enabled"
	eerror "Please, enable ${2} or disable ${1}"
}

pkg_setup() {
	local use_error=false

	if [[ $(gcc-major-version) -lt 3 ]]; then
		eerror "You need to use gcc-3 at least."
		eerror "Please change gcc version with 'gcc-config'."
		die "You need to use gcc-3 at least."
	fi

	# stop emerge if a conditional use flag is not respected

	if use rfc4175 && ! use video; then
		conditional_use_error_msg "rfc4175" "video"
		use_error=true
	fi

	if use h281 && ! use h224; then
		conditional_use_error_msg "h281" "h224"
		use_error=true
	fi

	if use x264-static && ! use x264; then
		conditional_use_error_msg "x264-static" "x264"
		use_error=true
	fi

	if ${use_error}; then
		eerror "Please see messages above and re-emerge ${PN} accordingly."
		die "Conditional USE flag error."
	fi

	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	# move files from doc tarball into ${S}
	if use doc; then
		mv ../html . || die "moving doc files failed"
	fi

	# remove visual studio related files from samples/
	if use examples; then
		rm -f samples/*/*.vcproj
		rm -f samples/*/*.sln
		rm -f samples/*/*.dsp
		rm -f samples/*/*.dsw
	fi

	# fix as-needed and aclocal, upstream patch 2795827
	epatch "${FILESDIR}"/${P}-as-needed.patch

	# use system ilbc, upstream patch 2795830
	epatch "${FILESDIR}"/${P}-system-ilbc.patch

	# fix sbc plugin link, upstream patch 2796087
	epatch "${FILESDIR}"/${P}-sbc.patch

	# upstream patch 2808915
	epatch "${FILESDIR}"/${P}-jdkroot.patch

	epatch "${FILESDIR}"/${P}-gcc-4.4.patch

	# h224 really needs h323 ?
	# TODO: get a confirmation in ml
	sed -i -e "s:\(.*HAS_H224.*\), \[OPAL_H323\]:\1:" configure.ac \
		|| die "sed failed"

	eaclocal
	eautoconf

	# in plugins
	cd plugins/
	eaclocal
	eautoconf
	cd ..

	# disable srtp if srtp is not enabled (prevent auto magic dep)
	# upstream bug 2686485 (fixed in 3.7)
	if ! use srtp; then
		sed -i -e "s/OPAL_SRTP=yes/OPAL_SRTP=no/" configure \
			|| die "patching configure failed"
	fi

	# disable theora if theora is not enabled (prevent auto magic dep)
	# upstream bug 2686488 (fixed in 3.7)
	if ! use theora; then
		sed -i -e "s/HAVE_THEORA=yes/HAVE_THEORA=no/" plugins/configure \
			|| die "patching plugins/configure failed"
	fi

	# disable mpeg4 and h263p if ffmpeg is not enabled (prevent auto magic dep)
	# upstream bug 2686495 (fixed in 3.7)
	if ! use ffmpeg; then
		sed -i -e "s/HAVE_H263P=yes/HAVE_H263P=no/" plugins/configure \
			|| die "patching plugins/configure failed"
		sed -i -e "s/HAVE_MPEG4=yes/HAVE_MPEG4=no/" plugins/configure \
			|| die "patching plugins/configure failed"
	fi

	# fix gsm wav49 support check, upstream bug 2686500 (fixed in 3.7)
	if use plugins; then
		sed -i -e "s:gsm\.h:gsm/gsm.h:" plugins/configure \
			|| die "patching plugins/configure failed"
	fi

	# fix automatic swig detection, upstream bug 2712521 (upstream reject it)
	if ! use swig; then
		sed -i -e "/^SWIG=/d" configure || die "patching configure failed"
	fi

	java-pkg-opt-2_src_prepare
}

src_configure() {
	local forcedconf=""

	# fix bug 277233, upstream bug 2820939
	if use fax; then
		forcedconf="${forcedconf} --enable-statistics"
	fi

	# --with-libavcodec-source-dir should _not_ be set, it's for trunk sources
	# versioncheck: check for ptlib version
	# shared: should always be enabled for a lib
	# localspeex, localspeexdsp, localgsm, localilbc: never use bundled libs
	# samples: only build some samples, useless
	# libavcodec-stackalign-hack: prevent hack (default disable by upstream)
	# default-to-full-capabilties: default enable by upstream
	# aec: atm, only used when bundled speex, so it's painless for us
	# zrtp doesn't depend on net-libs/libzrtpcpp but on libzrtp from
	# 	http://zfoneproject.com/ wich is not in portage
	# msrp: highly experimental
	# spandsp: doesn't work with newest spandsp, upstream bug 2796047
	# g711plc: force enable
	# rfc4103: not really used, upstream bug 2795831
	# t38, spandsp: merged in fax
	# h450, h460, h501: merged in h323 (they are additional features of h323)
	econf \
		--enable-versioncheck \
		--enable-shared \
		--disable-zrtp \
		--disable-localspeex \
		--disable-localspeexdsp \
		--disable-localgsm \
		--disable-localilbc \
		--disable-samples \
		--disable-libavcodec-stackalign-hack \
		--enable-default-to-full-capabilties \
		--enable-aec \
		--disable-msrp \
		--disable-spandsp \
		--enable-g711plc \
		--enable-rfc4103 \
		$(use_enable debug) \
		$(use_enable capi) \
		$(use_enable fax) \
		$(use_enable fax t38) \
		$(use_enable ffmpeg ffmpeg-h263) \
		$(use_enable h224) \
		$(use_enable h281) \
		$(use_enable h323) \
		$(use_enable h323 h450) \
		$(use_enable h323 h460) \
		$(use_enable h323 h501) \
		$(use_enable iax) \
		$(use_enable ivr) \
		$(use_enable ixj) \
		$(use_enable java) \
		$(use_enable lid) \
		$(use_enable plugins) \
		$(use_enable rfc4175) \
		$(use_enable sbc) \
		$(use_enable sip) \
		$(use_enable sipim) \
		$(use_enable stats statistics) \
		$(use_enable video) \
		$(use_enable vpb) \
		$(use_enable x264 h264) \
		$(use_enable x264-static x264-link-static) \
		${forcedconf}
}

src_compile() {
	local makeopts=""

	use debug && makeopts="debug"

	emake ${makeopts} || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use doc; then
		dohtml -r html/* docs/* || die "dohtml failed"
	fi

	# ChangeLog is not standard
	dodoc ChangeLog-${PN}-v${PV//./_}.txt || die "dodoc failed"

	if use examples; then
		local exampledir="/usr/share/doc/${PF}/examples"
		local basedir="samples"
		local sampledirs="`ls ${basedir} --hide=configure* \
			--hide=opal_samples.mak.in`"

		# first, install files
		insinto ${exampledir}/
		doins ${basedir}/{configure*,opal_samples*} \
			|| die "doins failed"

		# now, all examples
		for x in ${sampledirs}; do
			insinto ${exampledir}/${x}/
			doins ${basedir}/${x}/* || die "doins failed"
		done

		# some examples need version.h
		insinto "/usr/share/doc/${PF}/"
		doins version.h || die "doins failed"
	fi
}

pkg_postinst() {
	if use examples; then
		ewarn "All examples have been installed, some of them will not work on your system"
		ewarn "it will depend of the enabled USE flags in ptlib and opal"
	fi

	if ! use plugins || ! use audio || ! use video; then
		ewarn "You have disabled audio, video or plugins USE flags."
		ewarn "Most audio/video features or plugins have been disabled silently"
		ewarn "even if enabled via USE flags."
		ewarn "Having a feature enabled via USE flag but disabled can lead to issues."
	fi
}
