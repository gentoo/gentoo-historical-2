# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/kadu/kadu-0.4.2.ebuild,v 1.2 2005/10/13 19:30:49 mkay Exp $

inherit flag-o-matic eutils

TCL="0.6.1-Isilmalinir"		#http://scripts.one.pl/tcl4kadu
TABS="rev38"				#http://gov.one.pl/svnsnap
AMAROK="1.13"				#http://scripts.one.pl/amarok
WEATHER="2.02"				#http://www.kadu.net/~blysk/
#EXT_INFO="2.0beta5"			#http://kadu-ext-info.berlios.de
EXT_INFO="1.4.3"
XMMS="1.25"					#http://scripts.one.pl/xmms
XOSD_NOTIFY="050607"		#http://www.kadu.net/~joi/xosd_notify
MAIL="0.2.0"				#http://michal.gov.one.pl/mail
SPELLCHECKER="0.15"			#http://scripts.one.pl/spellchecker
SPY="0.0.8-1"				#http://scripts.one.pl/~przemos/projekty/kaduspy/
FIREWALL="0.8"				#http://users.skorpion.wroc.pl/arturmat/firewall/
LED_NOTIFY="0.2"			#http://republika.pl/buysk/led_notify
SCREEN_SHOT="0.3.1"			#http://scripts.one.pl/screenshot
CONTACTS="1.0rc1"			#http://obeny.kicks-ass.net/obeny/kadu/modules/contacts
OSD_NOTIFY="0.2.6"			#http://www.kadu.net/~pan_wojtas/osdhints_notify/
THEMES="kadu-theme-crystal-16
	kadu-theme-crystal-22
	kadu-theme-gg3d
	kadu-theme-noia-16
	kadu-theme-nuvola-16
	kadu-theme-nuvola-22
	kadu-theme-old_default
	kadu-theme-piolnet
	kadu-theme-real_gg
	alt_cryst"				#http://www.kadu.net/download/additions

DESCRIPTION="QT client for popular in Poland Gadu-Gadu IM network"
HOMEPAGE="http://kadu.net/"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="debug alsa arts esd voice speech nas oss spell ssl tcltk
	xmms xosd amarok extraicons extramodules mail config_wizard"

DEPEND="=x11-libs/qt-3*
	alsa? ( media-libs/alsa-lib virtual/alsa
	media-libs/libsndfile )
	arts? ( kde-base/arts
			media-libs/libsndfile )
	esd? ( media-sound/esound
			media-libs/libsndfile )
	nas? ( media-libs/nas
			media-libs/libsndfile )
	oss? ( media-libs/libsndfile )
	config_wizard? ( media-libs/libsndfile )
	voice? ( media-libs/libsndfile )
	amarok? ( media-sound/amarok )
	spell? ( app-dicts/aspell-pl )
	ssl? ( dev-libs/openssl )
	speech? ( app-accessibility/powiedz )
	tcltk? ( >=dev-lang/tcl-8.4.0 >=dev-lang/tk-8.4.0 )
	xmms? ( media-sound/xmms )
	xosd? ( x11-libs/xosd )"


SRC_URI="http://kadu.net/download/stable/${P}.tar.bz2
	amarok? ( http://scripts.one.pl/amarok/stable/0.4.0/amarok-${AMAROK}.tar.gz )
	tcltk? ( http://scripts.one.pl/tcl4kadu/files/stable/${PV}/tcl_scripting-${TCL}.tar.gz )
	extraicons? (
	    http://biprowod.wroclaw.pl/kadu/kadu-theme-alt_cryst.tar.bz2
	    http://www.kadu.net/download/additions/kadu-theme-crystal-16.tar.bz2
	    http://www.kadu.net/download/additions/kadu-theme-crystal-22.tar.bz2
	    http://www.kadu.net/download/additions/kadu-theme-gg3d.tar.bz2
	    http://www.kadu.net/download/additions/kadu-theme-noia-16.tar.bz2
	    http://www.kadu.net/download/additions/kadu-theme-nuvola-16.tar.gz
	    http://www.kadu.net/download/additions/kadu-theme-nuvola-22.tar.gz
	    http://www.kadu.net/download/additions/kadu-theme-old_default.tar.bz2
	    http://www.kadu.net/download/additions/kadu-theme-piolnet.tar.bz2
	    http://www.kadu.net/download/additions/kadu-theme-real_gg.tar.bz2 )
	extramodules? (
		http://gov.one.pl/svnsnap/tabs-svn-${TABS}.tar.gz
	    http://www.kadu.net/~blysk/weather-${WEATHER}.tar.bz2
	    http://www.kadu.net/~dzwiedziu/pub/ext_info-${EXT_INFO}.tar.bz2
		http://scripts.one.pl/~przemos/download/kadu-spy-${SPY}.tar.gz
	    http://users.skorpion.wroc.pl/arturmat/firewall/files/firewall-${FIREWALL}.tar.bz2
	    http://pcb45.tech.us.edu.pl/~blysk/led_notify/led_notify-${LED_NOTIFY}.tar.bz2
		http://scripts.one.pl/screenshot/stable/0.4.0/screenshot-${SCREEN_SHOT}.tar.gz
		http://obeny.kicks-ass.net/obeny/kadu/modules/contacts/contacts-${CONTACTS}.tar.bz2
		http://www.kadu.net/~joi/kde_transparency.tar.bz2
		http://www.kadu.net/~pan_wojtas/osdhints_notify/download/kadu-osdhints_notify-${OSD_NOTIFY}.tar.gz )
	xmms? ( http://scripts.one.pl/xmms/devel/0.4.0/xmms-${XMMS}.tar.gz )
	xosd? ( http://www.kadu.net/~joi/xosd_notify/packages/xosd_notify-${XOSD_NOTIFY}.tar.bz2 )
	mail? ( http://michal.kernel-panic.cjb.net/mail/tars/release/mail-${MAIL}.tar.bz2 )
	spell? (
	http://scripts.one.pl/spellchecker/devel/${PV}/spellchecker-${SPELLCHECKER}.tar.gz
	)"


S=${WORKDIR}/${PN}

enable_module() {
	if use ${1}; then
	    mv ${WORKDIR}/${2} ${WORKDIR}/kadu/modules/
	    module_config ${2} m
	fi
}

module_config() {
	sed -i -r "s/(^module_${1}\\s*=\\s*).*/\\1${2}/" .config
}

spec_config() {
	sed -i -r "s/(^${2}\\s*=\\s*).*//" modules/${1}/spec
	echo "${2}=${3}" >> modules/${1}/spec
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# Disabling autodownload for modules
	rm -f ${WORKDIR}/kadu/modules/*.web

	# Disabling autodownload for icons
	rm -f ${WORKDIR}/kadu/varia/themes/icons/*.web

	# Disabling all modules and iconsets for further activation via USE flags
	sed .config -i -e 's/=m/=n/g'
	sed .config -i -e 's/=y/=n/g'

	# Enable default icon theme
	sed .config -i -e 's/icons_default=n/icons_default=y/'

	enable_module amarok amarok
	enable_module spell spellchecker
	enable_module xmms xmms
	enable_module xosd xosd_notify
	enable_module mail mail
	enable_module tcltk "tcl_scripting"

	enable_module extramodules weather
	enable_module extramodules ext_info
	enable_module extramodules spy
	enable_module extramodules led_notify
	enable_module extramodules tabs
	enable_module extramodules screenshot

	# put some patches
	epatch ${FILESDIR}/kadu-toolbar_toggle-gentoo.diff
	use xosd && epatch ${FILESDIR}/xosd-gentoo.patch
}

src_compile() {
	# Enabling default iconset
	module_config icons_default y

	# Enabling dependencies that are needed by other modules
	module_config account_management m
	module_config autoaway m
	module_config autoresponder m
	module_config dcc m
	module_config default_sms m
	module_config docking m
	module_config filedesc m
	module_config hints m
	module_config notify m
	module_config sms m
	module_config desktop_docking m
	use config_wizard && \
		( module_config sound m; module_config config_wizard m )

	if use extramodules; then
		if use !tcltk; then
			ewarn "script_chess depends on module_tcl_scripting;"
			ewarn "It won't be installed."
		fi
	fi

	# Firewall
	if use extramodules; then
		if use !tcltk; then
			ewarn "script_firewall depends on module_tcl_scripting;"
			ewarn "It won't be installed."
		fi
	fi

	use speech && module_config speech m
	use extramodules && module_config autoresponder

	# static modules (disable only, do not compile as .so)
	use ssl && module_config encryption y

	# dynamic modules
	use alsa 	&&	( module_config sound m; module_config alsa_sound m )
	use arts 	&& 	( module_config sound m; module_config arts_sound m )
	use esd 	&&	( module_config sound m; module_config esd_sound m )
	use nas 	&&	( module_config sound m; module_config nas_sound m )
	use voice 	&&	( module_config sound m; module_config voice m )
	use oss 	&&	( module_config sound m; module_config dsp_sound m )
	module_config x11_docking m
	module_config wmaker_docking m

	# Some fixes
	einfo "Fixing modules spec files"
	if use arts; then
	    spec_config arts_sound MODULE_INCLUDES_PATH "\"$(kde-config --prefix)/include $(kde-config --prefix)/include/artsc\""
	    spec_config arts_sound MODULE_LIBS_PATH $(kde-config --prefix)/lib
	fi
	if use amarok; then
	    spec_config amarok MODULE_INCLUDES_PATH $(kde-config --prefix)/include
	    spec_config amarok MODULE_LIBS_PATH $(kde-config --prefix)/lib
	fi

	if use extramodules; then
	    einfo "Changing default firewall log location to user's homedir/.gg/firewall.log"
	    sed ${WORKDIR}/firewall.tcl -i -e \
			's%$module(scriptpath)/firewall.log%$env(HOME)/.gg/firewall.log%g'
	fi

	local myconf
	myconf="${myconf} --enable-modules --enable-dist-info=Gentoo"

	use voice && myconf="${myconf} --enable-dependency-tracing"
	use debug && myconf="${myconf} --enable-debug"

	econf ${myconf} || die
	emake || die
}

src_install() {
	make \
		DESTDIR=${D} \
		install || die

	# Installing additional scripts and plugins
	# Chess and Firewall
	if use extramodules; then
	    if use tcltk; then
		einfo "Installing Chess script"
		insinto /usr/share/kadu/modules/data/tcl_scripting/scripts
		doins ${WORKDIR}/KaduChess/{data,pics,KaduChess.tcl}
		# small fix form author's site
		sed ${D}/usr/share/kadu/modules/data/tcl_scripting/scripts/KaduChess.tcl -i -e \
			's/on chat0 KC_recv KC_recv/on chat0 KC_recv/g'

		einfo "Installing Firewall module"
		doins ${WORKDIR}/firewall{.tcl,.png}
	    fi
	fi

	if use extraicons; then
	    einfo "Installing extra icons"
		for theme in ${THEMES}; do
			insinto /usr/share/kadu/themes/icons/${theme}
			doins ${WORKDIR}/${theme}/{icons.conf,*.png}
		done
	fi
}
